#!/bin/bash

#######################################
#                                     #
#    GitHub Repository Generator      #
#                                     #
#######################################

##############################################################################
# Author: promicrobial                                                        #
# Date: 21-01-2025                                                            #
# License: MIT                                                                #
# Version: 1.0.0                                                             #
#                                                                            #
# Description: Creates a standardized GitHub repository structure with        #
# common directories and files. Optionally initializes git repository.        #
# Can create additional directories for Quarto projects.              #
#                                                                            #
# Dependencies:                                                              #
#   - git: For repository initialization                                     #
#     https://git-scm.com                                                    #
#                                                                            #
# Usage: ./mkgithub.sh <directory_name> [-git] [-project]                       #
#   Options:                                                                 #
#     -git: Initialize git repository                                        #
#     -project: Create additional directories for Quarto projects        #
#                                                                            #
# Last updated: 15-07-25                                               #
##############################################################################

# Strict error handling
# -e: Exit immediately if a command exits with non-zero status
# -u: Treat unset variables as an error
# -o pipefail: Return value of a pipeline is the status of the last command to exit with a non-zero status
set -euo pipefail

# Source utility functions if available
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/bash-utils" ]]; then
    source "${SCRIPT_DIR}/bash-utils"
fi

################################################################################
# Functions                                                                     #
################################################################################

# Function: validate_directory_name
# Description: Validates directory name for illegal characters and proper format
# Arguments:
#   $1: Directory name to validate
# Returns: 0 if valid, 1 if invalid
# Usage: validate_directory_name "my-repo"
validate_directory_name() {
    local dir_name="$1"
    # Check for illegal characters
    if [[ "$dir_name" =~ [[:space:]/\\*?] ]]; then
        log_error "Directory name contains illegal characters"
        return 1
    fi
    # Check if name starts with a letter or number
    if ! [[ "$dir_name" =~ ^[a-zA-Z0-9] ]]; then
        log_error "Directory name must start with a letter or number"
        return 1
    fi
    return 0
}

# Function: create_standard_structure
# Description: Creates the standard directory structure for a GitHub repository
# Arguments:
#   $1: Base directory name
# Usage: create_standard_structure "my-repo"
create_standard_structure() {
    local base_dir="$1"
    local dirs=("_assets" "src" "test" "scripts")
    
    for dir in "${dirs[@]}"; do
        mkdir -p "${base_dir}/${dir}"
        log_info "Created directory: ${dir}"
    done
}

# Function: create_proj_structure
# Description: Creates additional directories for Quarto projects
# Arguments:
#   $1: Base directory name
# Usage: create_proj_structure "my-repo"
create_proj_structure() {
    local base_dir="$1"
    local proj_dirs=("data" "ref" "results" "manuscript" "analysis" "utils")
    
    rm -r src || true  # Remove src if it exists to avoid conflicts

    for dir in "${proj_dirs[@]}"; do
        mkdir -p "${base_dir}/${dir}"
        log_info "Created projlication directory: ${dir}"
    done
}

# Function: initialize_git
# Description: Initializes a git repository and creates initial commit
# Arguments:
#   $1: Directory path
# Usage: initialize_git "my-repo"
initialize_git() {
    local dir="$1"
    cd "$dir" || exit 1
    if [[ ! -d ".git" ]]; then
        git init
        git add .
        git commit -m "Initial commit: Repository structure setup"
        log_info "Initialized git repository"
    else
        log_warn "Git repository already exists"
    fi
}

# Function: create_base_files
# Description: Creates basic repository files with templates
# Arguments:
#   $1: Directory path
# Usage: create_base_files "my-repo"
create_base_files() {
    local dir="$1"
    
    # Create README with template
    cat > "${dir}/README.md" << EOF
# $(basename "$dir")

## Description
Brief description of your project.

## Installation
Installation instructions here.

## Usage
Usage instructions here.

## Contributing
Contributing guidelines here.

## License
License information here.
EOF
    
    # Create basic .gitignore
    wget -O ${dir}/.gitignore https://raw.githubusercontent.com/promicrobial/Assets/refs/heads/main/.gitignore
    
    # Create empty LICENSE file
    touch "${dir}/LICENSE"
    
    log_info "Created base repository files"
}

################################################################################
# Main Script Execution                                                         #
################################################################################

# Function: main
# Description: Main script execution
# Arguments:
#   $@: All script arguments
# Usage: main "$@"
main() {
    # Validate input
    if [[ $# -lt 1 ]]; then
        log_error "No directory name provided"
        echo "Usage: $(basename "$0") <directory_name> [-git] [-project]"
        exit 1
    fi
    
    local dir_name="$1"
    local git=0
    local proj=0
    
    # Validate directory name
    if ! validate_directory_name "$dir_name"; then
        exit 1
    fi
    
    # Parse flags
    shift
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -git) git=1 ;;
            -project) proj=1 ;;
            *) log_warn "Unknown option: $1" ;;
        esac
        shift
    done
    
    # Create main structure
    create_standard_structure "$dir_name"
    
    # Create proj structure if requested
    if [[ $proj -eq 1 ]]; then
        create_proj_structure "$dir_name"
    fi
    
    # Create base files
    create_base_files "$dir_name"
    
    # Initialize git if requested
    if [[ $git -eq 1 ]]; then
        initialize_git "$dir_name"
    fi
    
    log_info "Repository structure created successfully in: $dir_name"
}

# Execute main function if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi