#!/bin/bash

# Function to check if directory exists
check_chezmoi_dir() {
    local chezmoi_dir="$HOME/.local/share/chezmoi"
    if [ ! -d "$chezmoi_dir" ]; then
        echo "Error: Chezmoi directory not found at $chezmoi_dir"
        exit 1
    fi
    cd "$chezmoi_dir" || exit 1
}

# Function to rename files recursively
rename_files_recursive() {
    local count=0
    
    # Find all files starting with readonly_ recursively
    while IFS= read -r -d '' file; do
        # Get the directory path of the file
        dir=$(dirname "$file")
        # Get the base name of the file
        base=$(basename "$file")
        # Create new filename by removing readonly_ prefix
        new_name="$dir/${base#readonly_}"
        
        # Rename the file
        if mv "$file" "$new_name"; then
            echo "Renamed: $file → $new_name"
            ((count++))
        else
            echo "Error renaming $file"
        fi
    done < <(find . -name "readonly_*" -print0)
    
    if [ $count -eq 0 ]; then
        echo "No readonly_ files found"
    else
        echo "Successfully renamed $count files"
    fi
}

# Main execution
echo "Starting recursive chezmoi file renaming process..."
check_chezmoi_dir
rename_files_recursive
echo "Process complete"
