#!/usr/bin/env bash

if [[ -f $1 ]]; then
	height=$(sips -g pixelHeight "$1"|tail -n 1|awk '{print $2}')
	width=$(sips -g pixelWidth "$1"|tail -n 1|awk '{print $2}')
	echo "${width} x ${height}"
else
	echo "File not found"
fi
