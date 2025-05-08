#!/bin/bash

set -e

# Usage function
usage() {
    echo "Usage: $0 analysis_name search_path [search_pattern] [awk_pattern] [file]"
    echo "Example: $0 fastp data/processed/fastp '*.html' 'SO.*(?<=_E|_B|_M)' data/processed/checklist.csv"
    exit 1
}

# Check minimum required arguments
if [ "$#" -lt 2 ]; then
    usage
fi

# Parameters with defaults
analysis_name="$1"
search_path="$2"
search_pattern="${3:-"*.html"}"
awk_pattern="${4:-"SO.*(?<=_E|_B|_M)"}"
file="${5:-"data/processed/process-checklist.tsv"}"

# Create temporary file for new analysis
find "$search_path" -name "$search_pattern" | \
    awk 'match($0, /('$awk_pattern')/, arr) {print arr[1]}' | sort > temp_new.txt

# If file doesn't exist, create with header and first column
if [ ! -f "$file" ]; then
    # Create header and data
    echo "$analysis_name" > "$file"
    cat temp_new.txt >> "$file"
else
# For adding new columns:
    # 1. Get the header line
    head -n 1 "$file" > header.tmp
    # 2. Get the data lines (excluding header)
    tail -n +2 "$file" > data.tmp
    
    # Add new column header
    echo -e "$(cat header.tmp)\t$analysis_name" > "$file"
    
    # Add new data
    paste -d '\t' data.tmp temp_new.txt >> "$file"
    
    # Clean up temporary files
    rm header.tmp data.tmp
fi

# Clean up
rm temp_new.txt

echo "Added $analysis_name column to $file"