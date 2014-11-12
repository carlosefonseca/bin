#!/usr/bin/env python

# -*- coding: utf-8 -*-

import json
import codecs
import sys
import locale
from subprocess import Popen, PIPE, STDOUT
import argparse

sys.stdout = codecs.getwriter(locale.getpreferredencoding())(sys.stdout);


# ARG PARSER

parser = argparse.ArgumentParser(description='Makes JSON readable.')

parser.add_argument("--no-color", dest="color", action="store_false", default=True, help="Don't pygmentize the output.")
parser.add_argument('infile', nargs='?', default=sys.stdin)

args = parser.parse_args()

isFile = type(args.infile) != file

# print "isFile:",isFile

j = ""

# READ 

if isFile:
    with codecs.open(args.infile, "r", "utf-8") as f:
        # print "loading file"
        j = json.loads(f.read())
else:
    # print "loading stdin"
    data = sys.stdin.read()
    if (len(data) == 0):
        # print sys.stdout.encoding
        # line = u"\u0411"
        # sys.stdout.write(line)
        # print line
        print u"No data \uD83D\uDCA9"
        sys.exit()
    j = json.loads(data)



# PROCESS

jj = json.dumps(j,sort_keys=True, indent=4, encoding="utf-8", ensure_ascii=False)


# WRITE 

if isFile:
    with codecs.open(args.infile, "w+", "utf-8") as f:
        f.write(jj)
else:
    if args.color:
        try:
            cmd = "pygmentize -O style=monokai -l json".split(" ")
            p = Popen(cmd, stdout=PIPE, stdin=PIPE, stderr=STDOUT)

            grep_stdout = p.communicate(input=jj)[0]
            print(grep_stdout)
        except Exception, e:
            print jj
    else:
        print jj
