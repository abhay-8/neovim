$ErrorActionPreference = "Stop"

Write-Host "Cleaning Neovim data directories..."

# Clear standard Windows local app data directories
Remove-Item -Path "$env:LOCALAPPDATA\nvim-data" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\state\nvim" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\nvim-cache" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Running clean installation..."
Write-Host "This might take a moment. Errors and logs will be written to build_errors.log"

# Run neovim headlessly to trigger lazy.nvim sync, and redirect all output to the log file
nvim --headless "+Lazy! sync" "+qa" *>&1 | Tee-Object -FilePath "build_errors.log"

Write-Host "Installation finished. Check build_errors.log for any errors."
