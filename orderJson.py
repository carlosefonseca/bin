#!/usr/bin/env python

# -*- coding: utf-8 -*-

import json
import codecs
import sys
import locale
from subprocess import Popen, PIPE, STDOUT

sys.stdout = codecs.getwriter(locale.getpreferredencoding())(sys.stdout);

j = ""
if len(sys.argv) > 1:
	with codecs.open(sys.argv[1], "r", "utf-8") as f:
		j = json.loads(f.read())
else:
	data = sys.stdin.read()
	if (len(data) == 0):
		print u"No data \uD83D\uDE1F"
		sys.exit()
	j = json.loads(data)

jj = json.dumps(j,sort_keys=True, indent=2)

if len(sys.argv) > 1:
	with codecs.open(sys.argv[1], "w+", "utf-8") as f:
		f.write(jj)
else:
	#cmd = "pygmentize -O style=monokai -l json".split(" ")
	#p = Popen(cmd, stdout=PIPE, stdin=PIPE, stderr=STDOUT)

	#formated = p.communicate(input=jj)[0]
	#print(formated)
	print jj