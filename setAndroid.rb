#!/usr/bin/env ruby

=begin

Processes the output of `adb devices` to be more user and machine friendly.
Can be used to verbosely list devices (device model, API version, brand) and to output a device id.
It can't set the ANDROID_SERIAL environment variable to be then used by adb, but can be included in an environment
function that does that. Here's what I use in by bash script:

setandroid() {
    # print device list
    setAndroid.rb
    # get device count
    n=$(setAndroid.rb simple | wc -l)
    if [ $n -eq 1 ]; then
        # if only one device, does not ask user
        number=1
    else
        # if more than one device, ask the user for which one
        read -p "Device: " number
    fi

    # if is number and within range
    if [[ "$number" =~ ^[0-9]+$ ]] && [ "$number" -ge 1 -a "$number" -le $n ]; then
        # obtains the device id, stores in env
        export ANDROID_SERIAL=$(setAndroid.rb ${number})
        # prints the current env
        env | grep ANDROID_SERIAL
        return 0
    fi
    echo "invalid"
    return 1
}

=end

index = ARGV[0].to_i
simple = ARGV[0] == 'simple'
help = (ARGV.length > 0 and ARGV[0].include? 'help')
input = ARGV[0] == 'ask'

if help
  puts 'Call with no arguments for verbose and indexed device list.'
  puts 'Call with a number to return the device id referring to that index.'
  puts 'Call with \'simple\' to return a list of device ids.'
  puts 'Call with \'ask\' to ask for a device id that will then be outputted (but not stored).'
  exit
end

# DEVICE LIST PROCESSING

x = `adb devices`.split "\n"
x = x.drop 1
x = x.map { |x| (x.split "\t")[0] }


# RETURNS PLAIN DEVICE ID LIST

if simple
  puts x
  exit
end


if index == 0

  # RETURNS VERBOSE DEVICE LIST

  y = x.map { |x|
    {
        :addr => x,
        :brand => `adb -s #{x} shell getprop ro.product.brand`.strip!,
        :manufacturer => `adb -s #{x} shell getprop ro.product.manufacturer`.strip!,
        :model => `adb -s #{x} shell getprop ro.product.model`.strip!,
        :release => `adb -s #{x} shell getprop ro.build.version.release`.strip!,
        :sdk => `adb -s #{x} shell getprop ro.build.version.sdk`.strip!
    }
  }

  y.each_with_index { |d, i|
    puts '%2d) %-25.25s  %-22s  %-5s %4s' % [i+1, d[:manufacturer]+" "+d[:model], d[:addr], d[:release], "(#{d[:sdk]})"]
  }


  # ASKS FOR AN INDEX AND OUTPUTS SPECIFIED DEVICE ID

  if input

    print 'Device: '
    x = $stdin.gets.strip.to_i
    if x.integer? and x > 0 and x <= y.length
      puts y[x-1][:addr]
      ENV['ANDROID_SERIAL'] = y[x-1][:addr]
    else
      puts 'invalid'
    end
  end


else

  # RETURNS DEVICE ID AT SPECIFIED INDEX

  puts x[index-1]

end