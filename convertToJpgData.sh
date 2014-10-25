#!/usr/bin/env bash

# run on assets folder:
# find . -name "6*" -exec ~/Downloads/convert.sh {} \;

echo $1
convert $1 $1.jpg
mv $1.jpg $1