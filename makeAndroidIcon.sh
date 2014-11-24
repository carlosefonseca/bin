#!/usr/bin/env bash

# $1 original
# $2 destination e.g. drawable/launcher_icon.png

if [[ $# -eq 2 ]]; then
	roundCorners.sh "$1" "$2"
	resizeAndroidIcon.sh "$2"
else
	echo "Usage:"
	echo "$0 original_image destination_image"
fi
