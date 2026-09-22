#!/bin/bash

inotifywait -m -e close_write,moved_to --format '%w%f' "$HOME/Downloads" | while read -r file; do
    if [[ "$file" == *.zip ]]; then
        unzip -o "$file" -d "${file%.zip}"
        rm "$file"
    fi
done
