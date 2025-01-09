#!/bin/bash

#######################################
#                                     #
#          File mover with            #
#    optional parallel processing     #
#                                     #
#######################################

##############################################################################
# Author: Nathaniel Cole (nc564@cornell.edu)                                 #
# GitHub: promicrobial (https://github.com/promicrobial)                     #
# Date: 19-06-24                                                             #
# License: MIT                                                               #
# Version: 1.0                                                               #
#                                                                            #
# Description:                                                               #
#   Moves files with specified extension to a target directory.              #
#   Provides both sequential and parallel processing options.                #
#   For large files, sequential processing may be more efficient due to      #
#   I/O limitations. Parallel processing may only be beneficial when         #
#   moving between different disks.                                          #
#                                                                            #
# Dependencies:                                                              #
#   - parallel: For parallel processing (optional)                           #
#                                                                            #
# Usage:                                                                     #
#   ./move_files.sh -e <extension> -d <destination> [-s <source>] [-p]       #
#                                                                            #
# Options:                                                                   #
#   -e, --extension    File extension to move (without dot)                  #
#   -d, --destination  Destination directory                                 #
#   -s, --source       Source directory (default: current directory)         #
#   -p, --parallel     Use parallel processing (may not improve performance) #
#                                                                            #
# Example:                                                                   #
#   ./move_files.sh -e fastq -d /path/to/dest -s /path/to/source             #
#                                                                            #
# Last updated: 09-01-25                                                     #
##############################################################################

# Citations:
# GNU Parallel (Tange, 2011)
#   - Citation: https://doi.org/10.5281/zenodo.10199085
#   - Website: https://www.gnu.org/software/parallel/

set -euo pipefail

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

################################################################################
# Help Function                                                                #
################################################################################

# Function: help
# Description: Display help message and usage information
# Arguments: none
# Usage: help
help() {
    cat << EOF
Description:
    Moves files with specified extension to a target directory.
    For large files, sequential processing is recommended due to I/O limitations.
    For many small files, parallel processing (-p) might improve performance.

Usage:
    $(basename "$0") -e EXTENSION -d DESTINATION [-s SOURCE] [-p]

Required Arguments:
    -e, --extension     File extension to move (without dot)
                       Example: fastq

    -d, --destination   Destination directory
                       Will be created if it doesn't exist

Optional Arguments:
    -s, --source       Source directory
                       Default: current directory

    -p, --parallel     Use parallel processing
                       Note: May not improve performance for large files
                       Requires GNU parallel to be installed
    --debug           Enable log_debug output
                      Prints detailed information about script execution    

    -h, --help         Display this help message

Examples:
    # Move all fastq files from current directory
    $(basename "$0") -e fastq -d /path/to/destination

    # Move files from specific source directory
    $(basename "$0") -e fastq -d /path/to/destination -s /path/to/source

    # Use parallel processing (for many small files)
    $(basename "$0") -e fastq -d /path/to/destination -p

Notes:
    - Parallel processing (-p) might not improve performance for large files
    - Source and destination can be on same or different drives
    - Script will create destination directory if it doesn't exist
    - Progress information is displayed during operation

EOF
}

################################################################################
# Global Variables and Settings                                                #
################################################################################

# Default values (can be overridden by the sourcing script)
DEBUG=false
SOURCE_DIR="."
USE_PARALLEL=false
EXTENSION=""
DESTINATION=""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;36m'
NC='\033[0m' # No Color

################################################################################
# Logging Functions                                                            #
################################################################################

# Function: log
# Description: Central logging function that handles all script output
# Arguments:
#   $1: Log level (INFO, WARN, ERROR, log_debug)
#   $2+: Message to log
# Usage: log "INFO" "Processing started"
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Color output based on log level
    case "$level" in
        "INFO") local color="${GREEN}" ;;  # Green
        "WARN") local color="${YELLOW}" ;;  # Yellow
        "ERROR") local color="${RED}" ;; # Red
        "DEBUG") local color="${BLUE}" ;; # Blue
        *) local color="${NC}" ;;         # Default
    esac
    local reset="${NC}"
    
    # Print to stderr so stdout can be used for data
    echo -e "${color}[$timestamp] $level: $message${reset}" >&2
}

# Convenience functions for different log levels
log_info() { log "INFO" "$@"; }
log_warn() { log "WARN" "$@"; }
log_error() { log "ERROR" "$@"; }
log_debug() {
    if [[ "$DEBUG" == "true" ]]; then
        log "DEBUG" "$@"
    fi
}

################################################################################
# Functions                                                                    #
################################################################################

# Function: create_directory
# Description: Creates a directory if it doesn't exist
# Arguments:
#   $1: Directory path
# Usage: create_directory "/path/to/dir"
create_directory() {
    local dir=$1
    if [[ ! -d "$dir" ]]; then
        log_debug "Creating directory: $dir"
        execute mkdir -p "$dir"
    else
        log_debug "Directory already exists: $dir"
    fi
}

# Function: move_files_sequential
# Description: Moves files sequentially
# Arguments:
#   $1: Source directory
#   $2: Destination directory
#   $3: File extension
# Usage: move_files_sequential "source" "dest" "ext"
# Function: move_files_sequential
# Description: Moves files sequentially
# Arguments:
#   $1: Source directory
#   $2: Destination directory
#   $3: File extension
# Usage: move_files_sequential "source" "dest" "ext"
move_files_sequential() {
    local source_dir=$1
    local dest_dir=$2
    local ext=$3
    local count=0
    
    # Store file list in an array
    local total=$(find "$source_dir" -maxdepth 1 -type f -name "*.$ext" | wc -l)

    log_info "Found $total files with extension .$ext"

    if [[ $total -eq 0 ]]; then
        log_warn "No files found with extension .$ext"
        return 0
    fi
    
    log_info "Moving all .$ext files from $source_dir to $dest_dir..."
    mv "$source_dir"/*."$ext" "$dest_dir"/

    return 0
}

# Function: move_files_parallel
# Description: Moves files in parallel using GNU parallel
# Arguments:
#   $1: Source directory
#   $2: Destination directory
#   $3: File extension
# Usage: move_files_parallel "source" "dest" "ext"
move_files_parallel() {
    local source_dir=$1
    local dest_dir=$2
    local ext=$3
    local total=$(find "$source_dir" -maxdepth 1 -type f -name "*.$ext" | wc -l)
    
    log_info "Found $total files with extension .$ext"
    
    if ! command -v parallel >/dev/null 2>&1; then
        log_error "GNU parallel is not installed. Falling back to sequential processing."
        move_files_sequential "$source_dir" "$dest_dir" "$ext"
        return
    fi
    
    find "$source_dir" -maxdepth 1 -type f -name "*.$ext" | \
        parallel --bar mv {} "$dest_dir/"
}

################################################################################
# Main script body                                                            #
################################################################################

main() {
    local start_time=$(date +%s)
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -e|--extension)
                EXTENSION="$2"
                shift 2
                ;;
            -d|--destination)
                DESTINATION="$2"
                shift 2
                ;;
            -s|--source)
                SOURCE_DIR="$2"
                shift 2
                ;;
            -p|--parallel)
                USE_PARALLEL=true
                shift
                ;;
            --debug)
            	DEBUG=true
                log_debug "Debug mode enabled"
                shift
                ;;
            -h|--help)
                help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                help
                exit 1
                ;;
        esac
    done

    # Verify required arguments
    if [ -z "$EXTENSION" ] || [ -z "$DESTINATION" ]; then
        log_error "Extension (-e) and destination (-d) are required"
        help
        exit 1
    fi

    # Create destination directory if it doesn't exist
    create_directory "$DESTINATION"

    # Move files based on selected method
    if [ "$USE_PARALLEL" = true ]; then
        log_info "Using parallel processing..."
        move_files_parallel "$SOURCE_DIR" "$DESTINATION" "$EXTENSION"
    else
        log_info "Using sequential processing..."
        move_files_sequential "$SOURCE_DIR" "$DESTINATION" "$EXTENSION"
    fi

    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    log_info "Operation completed in $duration"
}

# If being sourced, don't execute main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
