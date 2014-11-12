#!/usr/bin/env bash

if [[ $# -eq 2 ]]; then
	mkdir -p "$(dirname $2)"
	convert "$1" \( +clone -alpha extract -draw 'fill black polygon 0,0 0,200 200,0 fill white circle 200,200 200,0' \( +clone -flip \) -compose Multiply -composite \( +clone -flop \) -compose Multiply -composite \) -alpha off -compose CopyOpacity -composite "$2"
else
	echo "Usage:"
	echo "$0 start_image_path result_image_path"
fi