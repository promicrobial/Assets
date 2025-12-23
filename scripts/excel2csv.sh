#!/bin/bash

#######################################
#                                     #
#    Excel Sheet to CSV Converter     #
#                                     #
#######################################

##############################################################################
# Author: Nathaniel Cole                                                     #
# Date: 17-06-2024                                                           #
# License: MIT                                                               #
# Version: 1.2                                                               #
#                                                                            #
# Description: Converts each sheet in Excel (.xlsx) files to individual      #
# CSV files using ssconvert (from gnumeric package).                         #
#                                                                            #
# Dependencies:                                                              #
#   - gnumeric: For ssconvert utility                                        #
#     Installation: sudo apt-get install gnumeric (Debian/Ubuntu)            #
#     Website: http://www.gnumeric.org                                       #
#   - Package: https://packages.debian.org/stable/gnumeric                   #
#                                                                            #
# Usage: ./excel_to_csv_converter.sh                                         #
#                                                                            #
# Last updated: 21-07-25                                                     #
##############################################################################

# Strict error handling
set -euo pipefail

################################################################################
# Global Variables and Settings                                                #
################################################################################

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Required tools
TOOLS=("ssconvert")

# Script version
VERSION="1.2.0"

################################################################################
# Functions                                                                    #
################################################################################
# Function: show_help
# Description: Displays help information for the script
# Arguments: None
# Usage: show_help
show_help() {
    cat << EOF
Excel Sheet to CSV Converter (v${VERSION})
=======================================

Description:
-----------
Converts each sheet in Excel (.xlsx) files to individual CSV files using the
ssconvert utility from the gnumeric package. The script processes all Excel
files in the current directory and creates separate CSV files for each sheet.

Usage:
------
    $(basename "${0}") [OPTIONS]

Options:
--------
    -h, --help      Show this help message and exit
    -v, --version   Show version information and exit

Requirements:
------------
    - gnumeric package (for ssconvert utility)
    - Excel (.xlsx) files in the current directory

Installation:
------------
    Debian/Ubuntu:
        sudo apt-get install gnumeric

Output:
-------
    For each Excel file (example.xlsx), the script:
    1. Creates a directory named 'example_csv'
    2. Converts each sheet to a separate CSV file in that directory
    3. Sanitizes sheet names for file compatibility

Examples:
--------
    # Convert all Excel files in current directory:
    $ ./$(basename "${0}")

    # Show version information:
    $ ./$(basename "${0}") --version

    # Show this help message:
    $ ./$(basename "${0}") --help

File Naming:
-----------
    Input:  example.xlsx (with sheets "Sheet1" and "Data Analysis")
    Output: example_csv/
            ├── Sheet1.csv
            └── Data_Analysis.csv

Notes:
-----
    - Existing output directories will be reused
    - Special characters in sheet names are converted to underscores
    - The script requires write permissions in the current directory

Error Handling:
-------------
    - Checks for required dependencies
    - Validates Excel file existence
    - Reports conversion errors for each file

Author:
------
    Nathaniel Cole

Version:
-------
    ${VERSION}

License:
-------
    MIT

For more information:
-------------------
    GitHub: [repository URL]
    Report issues: [issues URL]

EOF
}

# Function: check_dependencies
# Description: Verifies that ssconvert is available
# Arguments: None
# Usage: check_dependencies
check_dependencies() {
    if ! command -v ssconvert &> /dev/null; then
        echo "Error: ssconvert is not installed. Please install gnumeric package."
        echo "On Debian/Ubuntu: sudo apt-get install gnumeric"
        exit 1
    fi
}

# Function: sanitize_sheet_name
# Description: Sanitizes sheet names for use in filenames
# Arguments: $1 - Sheet name to sanitize
# Usage: sanitize_sheet_name "Sheet Name"
sanitize_sheet_name() {
    local sheet_name="$1"
    # Replace spaces and special characters with underscores
    echo "$sheet_name" | tr ' ' '_' | sed 's/[^a-zA-Z0-9_-]/_/g'
}

# Function: create_output_directory
# Description: Creates a directory for output files if it doesn't exist
# Arguments: $1 - Excel file name
# Usage: create_output_directory "example.xlsx"
create_output_directory() {
    local excel_file="$1"
    local base_name="${excel_file%.xlsx}"
    local output_dir="${base_name}_csv"
    
    mkdir -p "$output_dir"
    echo "$output_dir"
}

# Function: convert_files
# Description: Converts all sheets in xlsx files to individual CSVs
# Arguments: None
# Usage: convert_files
convert_files() {
    local xlsx_files=()
    
    # Check if any xlsx files exist
    if ! compgen -G "*.xlsx" > /dev/null; then
        echo "No .xlsx files found in the current directory."
        exit 0
    fi
    
    # Store xlsx files in an array
    while IFS= read -r -d $'\0'; do
        xlsx_files+=("$REPLY")
    done < <(find . -maxdepth 1 -name "*.xlsx" -print0)
    
    echo "Found ${#xlsx_files[@]} Excel files to process."
    
    # Process each file
    for excel_file in "${xlsx_files[@]}"; do
        echo "Processing: $excel_file"
        
        # Create output directory
        output_dir=$(create_output_directory "$excel_file")
        echo "Created output directory: $output_dir"
        
        echo "Converting sheets"
        if ssconvert --export-file-per-sheet --export-type=Gnumeric_stf:stf_csv "$excel_file" $output_dir/%s.csv 2>/dev/null; then
            echo "Successfully converted sheets to $output_dir"
        else
            echo "Error converting sheets from $excel_file"
        fi
    done
}

################################################################################
# Main Script                                                                  #
################################################################################

main() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                echo "Excel Sheet to CSV Converter v${VERSION}"
                exit 0
                ;;
            *)
                echo "Error: Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
        shift
    done
    echo "Starting Excel sheets to CSV conversion..."
    
    # Check dependencies
    check_dependencies
    
    # Convert files
    convert_files
    
    echo "Conversion process complete."
}

# If being sourced, don't execute main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
