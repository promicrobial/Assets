#!/bin/bash

#######################################
#                                     #
#        CSV Row Remover              #
#                                     #
#######################################

##############################################################################
# Author: Nathaniel Cole (nc564@cornell.edu)                                 #
# GitHub: promicrobial (https://github.com/promicrobial)                     #
# Date:                                                                      #
# License: MIT or GLP-3.0                                                    #
# Version: 1.0                                                               #
#                                                                            #
# Description: Removes a specified row from a CSV file. Can modify the file  #
# in place or create a new output file.                                      #
#                                                                            #
# Usage: $(basename "${0}") [OPTIONS] <input_file.csv>                       #
#                                                                            #
##############################################################################

# Strict error handling
# -e: Exit immediately if a command exits with non-zero status
# -u: Treat unset variables as an error
# -o pipefail: Return value of a pipeline is the status of the last command to exit with a non-zero status
set -euo pipefail

# Script version
VERSION="1.0.0"

# Function: show_help
# Description: Displays help information for the script
# Arguments: None
show_help() {
    cat << EOF
CSV Row Remover (v${VERSION})
============================

Description:
-----------
Removes a specified row from a CSV file. Can modify the file in place
or create a new output file.

Usage:
------
    $(basename "${0}") [OPTIONS] <input_file.csv>

Options:
--------
    -h, --help          Show this help message and exit
    -r, --row NUM       Specify row number to remove (default: 1)
    -o, --output FILE   Output to new file instead of modifying in place
    -v, --version       Show version information and exit

Examples:
--------
    # Remove first row from file.csv (modifies in place):
    $ $(basename "${0}") file.csv

    # Remove third row and save to new file:
    $ $(basename "${0}") -r 3 -o new_file.csv file.csv

    # Show this help message:
    $ $(basename "${0}") --help

EOF
}

# Default values
row_to_remove=1
output_file=""
input_file=""

# Process command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -v|--version)
            echo "CSV Row Remover v${VERSION}"
            exit 0
            ;;
        -r|--row)
            if [[ -n ${2-} ]]; then
                if [[ $2 =~ ^[0-9]+$ ]]; then
                    row_to_remove=$2
                    shift 2
                else
                    echo "Error: Row number must be a positive integer"
                    exit 1
                fi
            else
                echo "Error: --row requires a number"
                exit 1
            fi
            ;;
        -o|--output)
            if [[ -n ${2-} ]]; then
                output_file=$2
                shift 2
            else
                echo "Error: --output requires a filename"
                exit 1
            fi
            ;;
        *)
            if [[ -z $input_file ]]; then
                input_file=$1
                shift
            else
                echo "Error: Unknown option or multiple input files specified"
                echo "Use --help for usage information"
                exit 1
            fi
            ;;
    esac
done

# Validate input file
if [[ -z $input_file ]]; then
    echo "Error: No input file specified"
    echo "Use --help for usage information"
    exit 1
fi

if [[ ! -f $input_file ]]; then
    echo "Error: Input file '$input_file' not found"
    exit 1
fi

if [[ ! -r $input_file ]]; then
    echo "Error: Input file '$input_file' is not readable"
    exit 1
fi

# If no output file specified, create temporary file
if [[ -z $output_file ]]; then
    temp_file=$(mktemp)
    output_file=$temp_file
fi

# Remove specified row
sed "${row_to_remove}d" "$input_file" > "$output_file"

# If using temporary file, replace original with modified version
if [[ -n $temp_file ]]; then
    mv "$temp_file" "$input_file"
    echo "Removed row $row_to_remove from $input_file"
else
    echo "Created $output_file with row $row_to_remove removed"
fi