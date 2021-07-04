#!/bin/bash

idea_dist=""
default_idea_dir="/opt"
idea_installation_dir="$default_idea_dir"

function usage() {
    echo ""
    echo "This script will not download the Idea distribution. You must download Idea tar.gz distribution. Then use this script to install it."
    echo "Usage: "
    echo "install-idea.sh -f <idea_dist> [-p <idea_installation_dir>]"
    echo ""
    echo "-f: The idea tar.gz file."
    echo "-p: IntelliJ Idea installation directory. Default: $default_idea_dir."
    echo "-h: Display this help and exit."
    echo ""
}

function confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure?} [y/N] " response
    case $response in
    [yY][eE][sS] | [yY])
        true
        ;;
    *)
        false
        ;;
    esac
}

# Make sure the script is not running as root.
if [ "$UID" == "0" ]; then
    echo "You must not be root to run $0. Try following"
    echo "$0"
    exit 9
fi

while getopts "f:p:h" opts; do
    case $opts in
    f)
        idea_dist=${OPTARG}
        ;;
    p)
        idea_installation_dir=${OPTARG}
        ;;
    h)
        usage
        exit 0
        ;;
    \?)
        usage
        exit 1
        ;;
    esac
done

if [[ ! -f $idea_dist ]]; then
    echo "Please specify the Idea distribution file."
    echo "Use -h for help."
    exit 1
fi

# Validate Idea Distribution
idea_dist_filename=$(basename $idea_dist)

if [[ ${idea_dist_filename: -7} != ".tar.gz" ]]; then
    echo "Idea distribution must be a valid tar.gz file."
    exit 1
fi

# Create the default directory if user has not specified any other path
if [[ $idea_installation_dir == $default_idea_dir ]]; then
    mkdir -p $idea_installation_dir
fi

#Validate idea directory
if [[ ! -d $idea_installation_dir ]]; then
    echo "Please specify a valid Idea installation directory."
    exit 1
fi

echo "Installing: $idea_dist_filename"

# Check Idea executable
idea_exec="$(tar -tzf $idea_dist | grep ^[^/]*/bin/idea.sh$ || echo "")"

if [[ -z $idea_exec ]]; then
    echo "Could not find \"idea.sh\" executable in the distribution. Please specify a valid Idea distribution."
    exit 1
fi

# Idea Directory with version
idea_dir="$(echo $idea_exec | cut -f1 -d"/")"
extracted_dirname=$idea_installation_dir"/"$idea_dir

# Extract Idea Distribution
if [[ ! -d $extracted_dirname ]]; then
    echo "Extracting $idea_dist to $idea_installation_dir"
    sudo tar -xof $idea_dist -C $idea_installation_dir
    echo "Idea is extracted to $extracted_dirname"
else
    echo "WARN: Idea was not extracted to $idea_installation_dir. There is an existing directory with the name \"$idea_dir\"."
    if ! (confirm "Do you want to continue?"); then
        exit 1
    fi
fi

if [[ ! -f "${extracted_dirname}/bin/idea.sh" ]]; then
    echo "ERROR: The path $extracted_dirname is not a valid Idea installation."
    exit 1
fi

bash $extracted_dirname/bin/idea.sh

