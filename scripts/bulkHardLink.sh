#!/bin/bash

##
# Create hard links for files matching a pattern
#
# USAGE:
#   ./bulkHardLink.sh TARGET_PATH [LINK_DESTINATION] [PATTERN]
#
# ARGUMENTS:
#   TARGET_PATH        Source directory to search for files (required)
#   LINK_DESTINATION   Directory where hard links will be created (default: ./)
#   PATTERN           File pattern to match (default: *.pdf)
#
# EXAMPLES:
#   ./bulkHardLink.sh ~/path/to/files ~/Documents/PDF_Links
#   ./bulkHardLink.sh /path/to/docs ./links "*.txt"
#   ./bulkHardLink.sh ~/Downloads/papers
#
# NOTES:
#   - Hard links only work within the same filesystem
#   - Skips files that already have hard links in destination
#   - Handles duplicate filenames by appending counter
#   - Requires read access to source and write access to destination
##
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Validate arguments
if [[ $# -lt 1 ]]; then
    echo "Error: TARGET_PATH is required" >&2
    echo "Usage: $0 TARGET_PATH [LINK_DESTINATION] [PATTERN]" >&2
    exit 1
fi

TARGET_PATH="$1"
LINK_DESTINATION="${2:-./}"
PATTERN="${3:-*.pdf}"

# Validate source directory
if [[ ! -d "$TARGET_PATH" ]]; then
    echo "Error: Target path '$TARGET_PATH' does not exist or is not a directory" >&2
    exit 1
fi

# Create destination directory
if [[ ! -d "$LINK_DESTINATION" ]]; then
    mkdir -p "$LINK_DESTINATION"
fi

# Create temporary files for counters (to persist across subshells)
temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

counter_processed="$temp_dir/processed"
counter_linked="$temp_dir/linked"
counter_skipped="$temp_dir/skipped"

echo "0" > "$counter_processed"
echo "0" > "$counter_linked"
echo "0" > "$counter_skipped"

# Build associative array of existing inodes for efficiency
declare -A existing_inodes
while IFS= read -r -d '' existing_file; do
    if [[ -f "$existing_file" ]]; then
        inode=$(stat -c %i "$existing_file" 2>/dev/null || continue)
        existing_inodes["$inode"]="$existing_file"
    fi
done < <(find "$LINK_DESTINATION" -name "$PATTERN" -type f -print0 2>/dev/null)

# Process files
while IFS= read -r -d '' file; do
    # Increment processed counter
    echo $(($(cat "$counter_processed") + 1)) > "$counter_processed"
    
    filename=$(basename "$file")
    base_name="${filename%.*}"
    extension="${filename##*.}"

    # Check if this exact file already has a hard link in destination
    file_inode=$(stat -c %i "$file")
    
    if [[ -n "${existing_inodes[$file_inode]:-}" ]]; then
        echo $(($(cat "$counter_skipped") + 1)) > "$counter_skipped"
        continue
    fi
    
    # Handle duplicate filenames by adding counter
    counter=1
    target_name="$filename"
    target_path="$LINK_DESTINATION/$target_name"
    
    while [[ -e "$target_path" ]]; do
        target_name="${base_name}_${counter}.${extension}"
        target_path="$LINK_DESTINATION/$target_name"
        ((counter++))
    done
    
    # Create hard link
    if ln "$file" "$target_path" 2>/dev/null; then
        echo "Linked: $filename -> $target_name"
        # Add new link to tracking array
        existing_inodes["$file_inode"]="$target_path"
        echo $(($(cat "$counter_linked") + 1)) > "$counter_linked"
    else
        echo "Warning: Failed to create link for $filename" >&2
        echo $(($(cat "$counter_skipped") + 1)) > "$counter_skipped"
    fi
    
done < <(find "$TARGET_PATH" -name "$PATTERN" -type f -print0)

# Read final counters
total_processed=$(cat "$counter_processed")
total_linked=$(cat "$counter_linked")
total_skipped=$(cat "$counter_skipped")

# Summary
echo
echo "=== SUMMARY ==="
echo "Files processed: $total_processed"
echo "Files linked: $total_linked"
echo "Files skipped: $total_skipped"
echo "Destination: $LINK_DESTINATION"
