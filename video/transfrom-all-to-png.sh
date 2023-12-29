#!/bin/bash

# Search through all subdirectories in the current directory
for dir in */ ; do
    # If v.m3u8 file exists, update the references inside it
    if [[ -f "${dir}v.m3u8" ]]; then
        # Create a temporary file
        temp_file="${dir}temp.m3u8"
        touch "$temp_file"

        # Read and update the content of v.m3u8 file, then save it to the temporary file
        while IFS= read -r line; do
            # Find lines in the format "v{number}.ts" and replace them with "{number}.m3u8"
            if [[ "$line" == v*.ts ]]; then
                echo "$line" | sed -E 's/v([0-9]+)\.ts/\1_ts/' >> "$temp_file"
            else
                echo "$line" >> "$temp_file"
            fi
        done < "${dir}v.m3u8"

        mv "$temp_file" "${dir}v_m3u8"
        rm "${dir}v.m3u8"
    fi

    # Find and rename v{number}.ts files to {number}_ts
    for file in "${dir}"v*.ts; do
        if [[ -f "$file" ]]; then
            newname=$(echo "$file" | sed -E 's/v([0-9]+)\.ts/\1_ts/')
            mv "$file" "$newname"
        fi
    done


done
