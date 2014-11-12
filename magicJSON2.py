#!/usr/bin/env python

# -*- coding: utf-8 -*-

import json
import codecs
import sys
import locale
from subprocess import Popen, PIPE, STDOUT
import argparse


def convertTranslations(jj, translations):
	# print "------------------"
	# print "interating though"+json.dumps(jj)
	# print 
	if type(jj) == dict:
		for x in jj.keys():
			if type(jj[x]) == unicode:
				# print u"is "+jj[x]+"  in translations? "+str(jj[x] in translations)
				if (jj[x] in translations):
					# print u"changing "+x+" to "+translations[jj[x]]
					jj[x] = translations[jj[x]][:100]
			elif type(jj[x]) == list or type(jj[x]) == dict:
				convertTranslations(jj[x], translations)
	elif type(jj) == list:
		for x in jj:
			convertTranslations(x, translations)



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


# DO STUFF

def myupdate(x,y):
	x[1].update(y[1])
	return x

transl = reduce(myupdate, j["translations"].items())[1]


if "roadbooks" in j.keys():
	convertTranslations(j["roadbooks"], transl)
	jj = json.dumps(j["roadbooks"],sort_keys=True, indent=4)
elif "routes" in j.keys():
	convertTranslations(j["routes"], transl)
	jj = json.dumps(j["routes"],sort_keys=True, indent=4)
elif "routePoints" in j.keys():
	convertTranslations(j["routePoints"], transl)
	convertTranslations(j["pois"], transl)
	del[j["translations"]]
	jj = json.dumps(j,sort_keys=True, indent=4)
elif "activities" in j.keys():
	convertTranslations(j["activities"], transl)
	jj = json.dumps(j,sort_keys=True, indent=4)
elif "entity" in j.keys():
	convertTranslations(j["entity"], transl)
	jj = json.dumps(j["entity"], sort_keys=True, indent=4)


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
		except:
			print jj
	else:
		print jj
