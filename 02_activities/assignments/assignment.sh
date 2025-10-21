#!/bin/bash
set -euxo pipefail

############################################
# DSI CONSULTING INC. Project setup script #
############################################
# This script creates standard analysis and output directories
# for a new project. It also creates a README file with the
# project name and a brief description of the project.
# Then it unzips the raw data provided by the client.

if [ -d newproject ]; then
  echo "Directory 'newproject' already exists. Please remove it before running this script."
  exit 1
fi
mkdir -p newproject
cd newproject

mkdir -p analysis output
touch README.md
touch analysis/main.py

# download client data
curl -Lo rawdata.zip https://github.com/UofT-DSI/shell/raw/refs/heads/main/02_activities/assignments/rawdata.zip
unzip -q rawdata.zip

###########################################
# Complete assignment here

# 1. Create a directory named data
mkdir -p data

# 2. Move the ./rawdata directory to ./data/raw
mv ./rawdata ./data/raw

# 3. List the contents of the ./data/raw directory
ls ./data/raw

# 4. In ./data/processed, create directories for different log types
# Use brace expansion to create multiple directories with one command
mkdir -p ./data/processed/{server,user,event}_logs

# 5 & 6. Copy log files from raw to their respective processed directories
# Use a for loop to reduce code duplication
for log_type in server user event; do
    cp ./data/raw/*${log_type}*.log ./data/processed/${log_type}_logs/
done

# 7. For user privacy, remove all files containing IP addresses
# Use rm -f to prevent errors if no files match the pattern
rm -f ./data/raw/*ipaddr*.log
rm -f ./data/processed/user_logs/*ipaddr*.log

# 8. Create a sorted inventory of all files in the processed subfolders
# Pipe the output of 'find' to 'sort' for consistent, readable results
find ./data/processed -type f | sort > ./data/inventory.txt

###########################################

echo "Project setup is complete!"