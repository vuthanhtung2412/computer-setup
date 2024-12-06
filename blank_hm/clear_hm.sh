#!/bin/bash

set -e
parent_path=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
cd "$parent_path"

sed -e "s|<home>|$HOME|g" -e "s|<user>|$USER|g" "home_template.nix" >home.nix
home-manager -f ./home.nix switch

# Restore backup files

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No color

# Path to the .txt file containing the list of files
file_list="../backed_up_files.txt"

# Check if the list file exists
if [ ! -f "$file_list" ]; then
  echo -e "${RED}File list not found: $file_list${NC}"
  exit 1
fi

# Read each line from the file
while IFS= read -r file; do
  backup_file="${file}.bak"

  # Check if the backup file exists
  if [ -f "$backup_file" ]; then
    # Restore the file from backup
    cp "$backup_file" "$file"
    echo -e "${GREEN}✓ Restored: $file from $backup_file${NC}"
  else
    echo -e "${RED}✗ Backup not found for: $file${NC}"
  fi
done <"$file_list"
