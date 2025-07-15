#!/bin/bash

# Check if a directory name was provided as an argument
if [ -z "$1" ]; then
  echo "ERROR: No directory name provided.\nUsage: ./mkgithub.sh <directory_name> [-git]"
  exit 1
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed"
    exit 1
fi

# Set a default value for the -git flag
git=0

# Check if the -git flag is present in the command line arguments
for arg in "$@"
do
  if [ "$arg" == "-git" ]
  then
    git=1
  fi
done

# Set a default value for the -app flag
app=0

# Check if the -git flag is present in the command line arguments
for arg in "$@"
do
  if [ "$arg" == "-git" ]
  then
    app=1
  fi
done

# Set the name of the directory to be created
dir_name="$1"

# Create the main directory
mkdir -p "$dir_name"/{assets,resources,test,docs,tools}

if [ $app -eq 1 ]
then
  mkdir -p "$dir_name"/{src,.config,.build,dep,examples}
fi

# Create the files
cd "$dir_name"
touch README LICENSE .gitignore

# Initialize a new Git repository and add template
if [ $git -eq 1 ]
then
  echo "Creating a Git repository"
  if [ ! -d ".git" ]; then
      git init
      git add .
      git commit -m "Repo initialisation"
  fi
fi

# Confirm that the directories and file were created
echo "A GitHub repository template has been created successfully in $dir_name"