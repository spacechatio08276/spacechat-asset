#!/bin/bash

# Search through all subdirectories in the current directory
for dir in */ ; do
    # Check if v.m3u8 file exists, if so, rename it to v.png
    if [[ -f "${dir}v.m3u8" ]]; then
        mv "${dir}v.m3u8" "${dir}v.png"
    fi

    # Find and rename v{number}.ts files to {number}.png
    for file in "${dir}"v*.ts; do
        if [[ -f "$file" ]]; then
            newname=$(echo "$file" | sed -E 's/v([0-9]+)\.ts/\1.png/')
            mv "$file" "$newname"
        fi
    done

    # If v.png file exists, update the references inside it
    if [[ -f "${dir}v.png" ]]; then
        # Create a temporary file
        temp_file="${dir}temp.m3u8"
        touch "$temp_file"

        # Read and update the content of v.png file, then save it to the temporary file
        while IFS= read -r line; do
            # Find lines in the format "v{number}.ts" and replace them with "{number}.png"
            if [[ "$line" == v*.ts ]]; then
                echo "${line/v/}" | sed -E 's/([0-9]+)\.ts/\1.png/' >> "$temp_file"
            else
                echo "$line" >> "$temp_file"
            fi
        done < "${dir}v.png"

        # Move the temporary file to replace the original file
        mv "$temp_file" "${dir}v.png"
    fi
done
