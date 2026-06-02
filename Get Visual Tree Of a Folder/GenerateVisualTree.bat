<# :
@echo off
chcp 65001 >nul
echo Building visual project map with emojis...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$script = (Get-Content '%~f0' -Encoding UTF8 -Raw) -replace '(?s)\<#.*?#\>', ''; Invoke-Expression $script"
echo.
echo Success! Your project map is saved in "project_structure.txt"
echo.
pause
exit /b
#>

# --- POWERSHELL LOGIC STARTS HERE ---
$OutputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$rootName = (Get-Item .).Name
$outputFile = "project_structure.txt"

# Filters out messy/heavy system folders automatically
$excludePatterns = "^(\.git|node_modules|__pycache__|\.venv|venv|exports|project_structure\.txt)$"

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add("$rootName/")
$lines.Add("│")

function Build-Tree {
    param([string]$Path, [string]$Prefix, [int]$Depth)
    
    $items = Get-ChildItem -Path $Path -Force | Where-Object { $_.Name -notmatch $excludePatterns }
    # Sort: Folders first, then Files alphabetically
    $items = $items | Sort-Object @{Expression={$_.PSIsContainer};Descending=$true}, Name
    $total = $items.Count
    $count = 0
    
    foreach ($item in $items) {
        $count++
        $isLast = ($count -eq $total)
        $connector = if ($isLast) { "└── " } else { "├── " }
        $childPrefix = if ($isLast) { $Prefix + "    " } else { $Prefix + "│   " }
        
        if ($item.PSIsContainer) {
            # Emoji for Folders (Open for root-level, Closed for sub-folders)
            $emoji = if ($Depth -eq 0) { "📂" } else { "📁" }
            $lines.Add("$Prefix$connector$emoji $($item.Name)/")
            Build-Tree -Path $item.FullName -Prefix $childPrefix -Depth ($Depth + 1)
        } else {
            # Smart Emoji Mapper for Files
            $ext = $item.Extension.ToLower()
            $emoji = switch ($ext) {
                ".html" { "🌐" }
                ".css"  { "🎨" }
                ".js"   { "📜" }
                ".py"   { "🐍" }
                ".pyc"  { "🐍" }
                ".txt"  { "📝" }
                ".md"   { "📖" }
                ".json" { "⚙️" }
                ".bat"  { "💻" }
                ".sh"   { "💻" }
                default { 
                    if ($item.Name -match "^(\.env|\.gitignore|requirements\.txt)$") { "⚙️" }
                    else { "📄" }
                }
            }
            $lines.Add("$Prefix$connector$emoji $($item.Name)")
        }
    }
}

# Run the build process starting from current directory
Build-Tree -Path . -Prefix "" -Depth 0

# Save the output to a text file cleanly (UTF-8 BOM added here to fix Windows Notepad issues)
[System.IO.File]::WriteAllLines("$PWD\$outputFile", $lines, (New-Object System.Text.UTF8Encoding($true)))