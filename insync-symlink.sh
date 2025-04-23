#!/bin/bash
# Create symlinks for all items in ~/Insync/brettcrisp2@gmail.com/Google Drive/ to ~/brett/, replacing existing items
# Run after Insync setup and sync completion

# Paths
SRC_DIR="/home/brett/Insync/brettcrisp2@gmail.com/Google Drive"
DEST_DIR="/home/brett"
LOG_FILE="/home/brett/insync-symlink.log"

# Files/directories to exclude (critical home directory items)
EXCLUDE=("Google Drive" ".bashrc" ".bash_profile" ".zshrc" ".config" ".ssh" ".gnupg" ".vnc" ".local" ".cache")

# Ensure source directory exists
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: $SRC_DIR not found" | tee -a "$LOG_FILE"
    notify-send "Insync Symlink Error" "$SRC_DIR not found"
    exit 1
fi

# Create log file
echo "Symlink script run on $(date)" >> "$LOG_FILE"

# Iterate through all items in SRC_DIR, including hidden ones
find "$SRC_DIR" -maxdepth 1 -not -path "$SRC_DIR" -readable 2>>"$LOG_FILE" | while read -r item; do
    item_name=$(basename "$item")

    # Skip excluded items
    skip=false
    for excl in "${EXCLUDE[@]}"; do
        if [ "$item_name" = "$excl" ]; then
            skip=true
            break
        fi
    done
    if [ "$skip" = true ]; then
        echo "Skipped excluded item: $item_name" >> "$LOG_FILE"
        continue
    fi

    dest_path="$DEST_DIR/$item_name"

    # Remove existing file or directory in DEST_DIR
    if [ -e "$dest_path" ] || [ -L "$dest_path" ]; then
        rm -rf "$dest_path"
        echo "Removed existing $dest_path" >> "$LOG_FILE"
    fi

    # Create symlink
    ln -s "$item" "$dest_path"
    if [ $? -eq 0 ]; then
        echo "Created symlink: $dest_path -> $item" >> "$LOG_FILE"
    else
        echo "Failed to create symlink: $dest_path" >> "$LOG_FILE"
        notify-send "Insync Symlink Error" "Failed to create symlink for $item_name"
    fi
done

notify-send "Insync Symlink" "Symlink creation completed. Check $LOG_FILE"
