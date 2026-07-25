#!/bin/bash
set -e

echo "Cleaning Neovim data directories..."

# Clear standard Windows local app data directories
rm -rf ~/AppData/Local/nvim-data
rm -rf ~/AppData/Local/state/nvim
rm -rf ~/AppData/Local/nvim-cache

# Just in case XDG paths are used
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim

echo "Running clean installation..."
echo "This might take a moment. Errors and logs will be written to build_errors.log"

# Run neovim headlessly to trigger lazy.nvim sync, and redirect all output to the log file
nvim --headless "+Lazy! sync" "+qa" > build_errors.log 2>&1

echo "Installation finished. Please check build_errors.log in this directory for any issues."
