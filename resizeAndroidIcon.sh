#!/usr/bin/env bash

# $1 icon path e.g. drawable/launcher_icon.png

F=$(basename "$1")
D=$(dirname $(dirname "$1"))

mkdir -p $D/drawable-mdpi
mkdir -p $D/drawable-hdpi
mkdir -p $D/drawable-xhdpi
mkdir -p $D/drawable-xxhdpi
mkdir -p $D/drawable-xxxhdpi

/usr/local/bin/convert "$1" -resize 48x48 "$D/drawable-mdpi/$F"
/usr/local/bin/convert "$1" -resize 72x72 "$D/drawable-hdpi/$F"
/usr/local/bin/convert "$1" -resize 96x96 "$D/drawable-xhdpi/$F"
/usr/local/bin/convert "$1" -resize 144x144 "$D/drawable-xxhdpi/$F"
/usr/local/bin/convert "$1" -resize 196x196 "$D/drawable-xxxhdpi/$F"