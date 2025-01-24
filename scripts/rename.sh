#!/bin/bash

#######################################
#                                     #
#           Bulk file rename          #
#                                     #
#######################################

##############################################################################
# Author: Nathaniel Cole (nc564@cornell.edu)                                 #
# GitHub: promicrobial (https://github.com/promicrobial)                     #
# Date: 24-01-25                                                             #
# License: MIT                                                               #
# Version: 1.0                                                               #
#                                                                            #
# Description: Bulk rename files based on a common string                    #
#                                                                            #
# Usage: rename.sh <string>                                                  #
#                                                                            #
# Example: rename.sh _old                                                    #
#                                                                            #
#            document_old.pdf --> document.pdf                               #
#            image_old.jpg --> image.jpg                                     #
#            notes_old.txt --> notes.txt                                     #
#                                                                            #
# Last updated: 24-01-25                                                     #
##############################################################################


# Check if string to remove was provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 'string_to_remove'"
    echo "Example: $0 '_old'"
    exit 1
fi

string_to_remove="$1"
count=0

# First, preview the changes
echo "Preview of changes to be made:"
echo "-----------------------------"

for file in *; do
    # Skip if it's a directory
    [ -d "$file" ] && continue
    
    # Create new filename by removing the specified string
    newname="${file/$string_to_remove/}"
    
    # Only show files that will actually be changed
    if [ "$file" != "$newname" ]; then
        echo "'$file' -> '$newname'"
        count=$((count + 1))
    fi
done

# If no files would be changed, exit
if [ $count -eq 0 ]; then
    echo "No files found containing '$string_to_remove'"
    exit 0
fi

# Ask for confirmation
echo -e "\nFound $count file(s) to rename."
read -p "Do you want to proceed with renaming? (y/N): " confirm

if [[ $confirm =~ ^[Yy]$ ]]; then
    # Perform the actual renaming
    for file in *; do
        # Skip if it's a directory
        [ -d "$file" ] && continue
        
        # Create new filename by removing the specified string
        newname="${file/$string_to_remove/}"
        
        # Only rename if the filename would actually change
        if [ "$file" != "$newname" ]; then
            mv "$file" "$newname"
            echo "Renamed: '$file' -> '$newname'"
        fi
    done
    echo "Renaming complete!"
else
    echo "Operation cancelled."
fi
