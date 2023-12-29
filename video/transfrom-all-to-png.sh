




#!/bin/bash
# find folder
for dir in */ ; do
    #v.m3u8 to v.png
    if [[ -f "${dir}v.m3u8" ]]; then
        mv "${dir}v.m3u8" "${dir}v.png"
    fi

    #v{number}.ts to png
    for file in "${dir}"v*.ts; do
        if [[ -f "$file" ]]; then
            newname=$(echo "$file" | sed -E 's/v([0-9]+)\.ts/\1.png/')
            mv "$file" "$newname"
        fi
    done
done
