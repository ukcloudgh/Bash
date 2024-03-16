#!/bin/bash

# Configuration
backup_dir="/home/ontap_config_backups"
max_files=3

# Get unique hostname and backup frequencies
unique_patterns=$(find $backup_dir -type f -name "*.7z" | sed -E "s/([^\.]+\.[^\.]+)\.([^\.]+\.[^\.]+.7z)/\1/" | sort | uniq)

# Iterate through each unique pattern and keep only the latest 3 files
for pattern in $unique_patterns; do
    file_count=$(find $backup_dir -type f -wholename "${pattern}.*.7z" | wc -l)
    # If there are more than max_files, delete the older ones
    if [ $file_count -gt $max_files ]; then
        files_to_delete=$((file_count - max_files))
        find $backup_dir -type f -wholename "${pattern}.*.7z" | sort | head -n $files_to_delete | xargs rm -f
    fi
done
