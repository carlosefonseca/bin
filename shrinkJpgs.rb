#!/usr/bin/env bash

function convert {
  echo $1
  echo "convert $1 -background \"#FFFFFF\" -flatten -alpha off $1.jpg"
  $(convert $1 -background "#FFFFFF" -flatten -alpha off $1.jpg)
  echo "AA"
  `mv $1.jpg $1`
  echo "DONE…"
}

for f in $@
do
  echo $f
  qlmanage -p $f
  read -n1 -p "Convert to JPG? [yn] " doit
  case $doit in
    y|Y) convert $f ;;
    n|N) echo "No" ;;
    *) echo "uh?" ;;
  esac

done

