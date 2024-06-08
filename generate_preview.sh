#!/bin/sh

svgs=$(find ./stickers -type f -name "*.svg")
for svg in $svgs; do
	filename=$(basename "$svg")
	name="${filename%.*}"
	tmpoutfile="/tmp/$name.png"
	outfile="./previews/$name.png"

	if ! [ -f "$outfile" ]; then
		echo "Generating preview for $svg"
		
		# SVG to PNG
		inkscape --export-type=png "$svg" -d 300 -o "$tmpoutfile"
		# Preview text
		convert "$tmpoutfile" -fill blue -pointsize 125 -gravity center -draw "rotate -45 text 0,0 'github.com/rtfmkiesel/Stickers, CC0 1.0 Universal'" "$outfile"
		# Remove possible metadata
		exiftool -overwrite_original -all= "$outfile"
		# Add to README
		echo "![The $name sticker from github.com/rtfmkiesel/Stickers]($outfile)" >> README.md
		
		rm "$tmpoutfile"
	else
		echo "Skipping $svg, already exists"
	fi
done