#!/bin/bash

compare_sizes() {
    local file="$1"
    echo "Size comparison for: $file"
    echo "------------------------"
    echo "Actual size (bytes): $(stat --format="%s" "$file")"
    echo "Allocated blocks: $(stat --format="%b" "$file")"
    echo "Block size: $(stat --format="%B" "$file")"
    echo "Apparent size: $(du --apparent-size -h "$file" | cut -f1)"
    echo "Allocated size: $(du -h "$file" | cut -f1)"
    echo "System block size: $(getconf PAGESIZE)"
    echo "Filesystem block size: $(df --output=fstype "$file" | tail -n1 | xargs tune2fs -l 2>/dev/null | grep "Block size" | awk '{print $3}')"
}

compare_sizes "$1"
