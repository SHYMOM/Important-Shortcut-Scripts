# FileOrganizer.ps1
# Professional File Organizer & Archiver
# Supports all Unicode characters including Japanese, Chinese, Arabic, etc.

# Helper function for formatting file sizes - MUST BE DEFINED FIRST
function Format-FileSize {
    param([long]$Size)
    if ($Size -lt 1KB) { return "$Size B" }
    elseif ($Size -lt 1MB) { return "{0:N0} KB" -f ($Size / 1KB) }
    elseif ($Size -lt 1GB) { return "{0:N0} MB" -f ($Size / 1MB) }
    else { return "{0:N2} GB" -f ($Size / 1GB) }
}

# Color functions
function Write-ColorText {
    param([string]$Text, [string]$Color = "White")
    Write-Host $Text -ForegroundColor $Color
}

function Write-Success { param([string]$Text) Write-Host $Text -ForegroundColor Green }
function Write-Error { param([string]$Text) Write-Host $Text -ForegroundColor Red }
function Write-Warning { param([string]$Text) Write-Host $Text -ForegroundColor Yellow }
function Write-Info { param([string]$Text) Write-Host $Text -ForegroundColor Cyan }
function Write-Header { param([string]$Text) Write-Host $Text -ForegroundColor Magenta }

# Set console colors
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "White"
Clear-Host

# Header
Write-Info "==============================================================="
Write-Host "           PROFESSIONAL FILE ORGANIZER & ARCHIVER" -ForegroundColor White
Write-Host "              Automated Sorting, Renaming & Compression" -ForegroundColor White
Write-Info "==============================================================="
Write-Host ""

# Check for 7-Zip
$use7z = $false
if (Get-Command 7z -ErrorAction SilentlyContinue) {
    $use7z = $true
    Write-Success "[OK] 7-Zip detected - Using 7z format for better compression"
} else {
    Write-Warning "[WARNING] 7-Zip not found - Using PowerShell ZIP compression"
    Write-Warning "[INFO] Install 7-Zip for better compression ratios"
}
Write-Host ""

# Get all folders
$folders = Get-ChildItem -Directory | Where-Object { $_.Name -notmatch '^\.' }
$totalFolders = $folders.Count

if ($totalFolders -eq 0) {
    Write-Error "[ERROR] No folders found in current directory!"
    Write-Warning "[INFO] Place this script in the parent folder containing your organized folders."
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Info "[SCAN] Found $totalFolders folders to process"
Write-Info "[INFO] Starting in 3 seconds..."
Start-Sleep -Seconds 3
Write-Host ""

# Statistics
$processedFolders = 0
$errorCount = 0

# Process each folder
foreach ($folder in $folders) {
    $processedFolders++
    $folderName = $folder.Name
    $folderPath = $folder.FullName
    
    # Create safe name for files (replace problematic chars for filenames)
    $safeName = $folderName -replace '[\s&\(\)\[\]{}<>\\/|:\"*?]', '_'
    
    Write-Header "---------------------------------------------------------------"
    Write-Host "Processing [$processedFolders/$totalFolders]: " -NoNewline
    Write-Info $folderName
    Write-Header "---------------------------------------------------------------"
    
    # Get all files - FIXED: Use separate queries for each extension to ensure all images are found
    $pdfFiles = @(Get-ChildItem -Path $folderPath -Filter "*.pdf" -File)
    $mp3Files = @(Get-ChildItem -Path $folderPath -Filter "*.mp3" -File)
    
    # FIXED: Get images using multiple filters to ensure PNG, JPG, and JPEG are all found
    $pngFiles = @(Get-ChildItem -Path $folderPath -Filter "*.png" -File)
    $jpgFiles = @(Get-ChildItem -Path $folderPath -Filter "*.jpg" -File)
    $jpegFiles = @(Get-ChildItem -Path $folderPath -Filter "*.jpeg" -File)
    $imgFiles = @($pngFiles + $jpgFiles + $jpegFiles)
    
    # Also check for uppercase extensions (some systems use .PNG, .JPG)
    $pngFilesUpper = @(Get-ChildItem -Path $folderPath -Filter "*.PNG" -File)
    $jpgFilesUpper = @(Get-ChildItem -Path $folderPath -Filter "*.JPG" -File)
    $jpegFilesUpper = @(Get-ChildItem -Path $folderPath -Filter "*.JPEG" -File)
    $imgFiles += @($pngFilesUpper + $jpgFilesUpper + $jpegFilesUpper)
    
    $pdfCount = $pdfFiles.Count
    $mp3Count = $mp3Files.Count
    $imgCount = $imgFiles.Count
    
    Write-Warning "  [SCANNING] Analyzing files..."
    
    # Debug output to show what images were found
    if ($imgCount -gt 0) {
        Write-Info "    [DEBUG] Found $imgCount image(s):"
        foreach ($img in $imgFiles) {
            Write-Info "      - $($img.Name)"
        }
    }
    
    # Identify special PDFs
    $fullReportPdf = $null
    $legalDocPdf = $null
    
    foreach ($pdf in $pdfFiles) {
        if ($pdf.BaseName -match "Full_Report" -and -not $fullReportPdf) {
            $fullReportPdf = $pdf
            Write-Info "    [FOUND] Full Report: $($pdf.Name)"
        }
        elseif ($pdf.BaseName -match "Legal_Document" -and -not $legalDocPdf) {
            $legalDocPdf = $pdf
            Write-Info "    [FOUND] Legal Document: $($pdf.Name)"
        }
    }
    
    Write-Host "  [STATS] PDFs: $pdfCount | MP3s: $mp3Count | Images: $imgCount" -ForegroundColor White
    Write-Host ""
    
    # Renaming phase
    Write-Warning "  [RENAMING] Processing files..."
    
    # Rename PDFs first
    if ($fullReportPdf) {
        $newName = "$safeName`_Full_Report.pdf"
        $newPath = Join-Path $folderPath $newName
        if (-not (Test-Path $newPath)) {
            try {
                Rename-Item -Path $fullReportPdf.FullName -NewName $newName -ErrorAction Stop
                Write-Success "    [OK] $($fullReportPdf.Name) -> $newName"
                $fullReportPdf = Get-Item $newPath  # Update reference
            } catch {
                Write-Error "    [FAIL] Could not rename $($fullReportPdf.Name)"
                $errorCount++
            }
        } else {
            Write-Warning "    [SKIP] $newName already exists"
        }
    }
    
    if ($legalDocPdf) {
        $newName = "$safeName`_Legal_Document.pdf"
        $newPath = Join-Path $folderPath $newName
        if (-not (Test-Path $newPath)) {
            try {
                Rename-Item -Path $legalDocPdf.FullName -NewName $newName -ErrorAction Stop
                Write-Success "    [OK] $($legalDocPdf.Name) -> $newName"
                $legalDocPdf = Get-Item $newPath  # Update reference
            } catch {
                Write-Error "    [FAIL] Could not rename $($legalDocPdf.Name)"
                $errorCount++
            }
        } else {
            Write-Warning "    [SKIP] $newName already exists"
        }
    }
    
    # Handle extra PDFs - re-scan directory to avoid conflicts
    if ($pdfCount -gt 2) {
        $extraNum = 1
        $currentPdfs = @(Get-ChildItem -Path $folderPath -Filter "*.pdf" -File)
        foreach ($pdf in $currentPdfs) {
            # Skip already renamed special PDFs
            if ($pdf.Name -eq "$safeName`_Full_Report.pdf") { continue }
            if ($pdf.Name -eq "$safeName`_Legal_Document.pdf") { continue }
            
            $newName = "$safeName`_Document_$extraNum.pdf"
            $newPath = Join-Path $folderPath $newName
            if (-not (Test-Path $newPath)) {
                try {
                    Rename-Item -Path $pdf.FullName -NewName $newName -ErrorAction Stop
                    Write-Success "    [OK] $($pdf.Name) -> $newName"
                    $extraNum++
                } catch {
                    Write-Error "    [FAIL] Could not rename $($pdf.Name)"
                    $errorCount++
                }
            }
        }
    }
    
    # Rename MP3s - use the original list but check existence
    if ($mp3Count -gt 0) {
        # First MP3
        $src = $mp3Files[0]
        $dest = "$safeName.mp3"
        $destPath = Join-Path $folderPath $dest
        if (Test-Path $src.FullName) {
            if (-not (Test-Path $destPath)) {
                try {
                    Rename-Item -Path $src.FullName -NewName $dest -ErrorAction Stop
                    Write-Success "    [OK] $($src.Name) -> $dest"
                } catch {
                    Write-Error "    [FAIL] Could not rename $($src.Name)"
                    $errorCount++
                }
            } else {
                Write-Warning "    [SKIP] $dest already exists"
            }
        }
        
        # Second MP3 (if exists)
        if ($mp3Count -gt 1) {
            $src = $mp3Files[1]
            $dest = "$safeName`_Cover.mp3"
            $destPath = Join-Path $folderPath $dest
            if (Test-Path $src.FullName) {
                if (-not (Test-Path $destPath)) {
                    try {
                        Rename-Item -Path $src.FullName -NewName $dest -ErrorAction Stop
                        Write-Success "    [OK] $($src.Name) -> $dest"
                    } catch {
                        Write-Error "    [FAIL] Could not rename $($src.Name)"
                        $errorCount++
                    }
                } else {
                    Write-Warning "    [SKIP] $dest already exists"
                }
            }
        }
        
        # Third and beyond MP3s
        if ($mp3Count -gt 2) {
            for ($i = 2; $i -lt $mp3Count; $i++) {
                $src = $mp3Files[$i]
                $num = $i  # 2 becomes Cover_2, 3 becomes Cover_3, etc.
                $dest = "$safeName`_Cover_$num.mp3"
                $destPath = Join-Path $folderPath $dest
                if (Test-Path $src.FullName) {
                    if (-not (Test-Path $destPath)) {
                        try {
                            Rename-Item -Path $src.FullName -NewName $dest -ErrorAction Stop
                            Write-Success "    [OK] $($src.Name) -> $dest"
                        } catch {
                            Write-Error "    [FAIL] Could not rename $($src.Name)"
                            $errorCount++
                        }
                    } else {
                        Write-Warning "    [SKIP] $dest already exists"
                    }
                }
            }
        }
    }
    
    # Rename Images - FIXED: Now properly detects all image files
    if ($imgCount -gt 0) {
        if ($imgCount -eq 1) {
            # Single image - no number
            $src = $imgFiles[0]
            $ext = $src.Extension
            $dest = "$safeName`_Thumbnail$ext"
            $destPath = Join-Path $folderPath $dest
            if (Test-Path $src.FullName) {
                if (-not (Test-Path $destPath)) {
                    try {
                        Rename-Item -Path $src.FullName -NewName $dest -ErrorAction Stop
                        Write-Success "    [OK] $($src.Name) -> $dest"
                    } catch {
                        Write-Error "    [FAIL] Could not rename $($src.Name)"
                        $errorCount++
                    }
                } else {
                    Write-Warning "    [SKIP] $dest already exists"
                }
            }
        } else {
            # Multiple images - with numbers starting from 1
            for ($i = 0; $i -lt $imgCount; $i++) {
                $src = $imgFiles[$i]
                $ext = $src.Extension
                $num = $i + 1
                $dest = "$safeName`_Thumbnail_$num$ext"
                $destPath = Join-Path $folderPath $dest
                if (Test-Path $src.FullName) {
                    if (-not (Test-Path $destPath)) {
                        try {
                            Rename-Item -Path $src.FullName -NewName $dest -ErrorAction Stop
                            Write-Success "    [OK] $($src.Name) -> $dest"
                        } catch {
                            Write-Error "    [FAIL] Could not rename $($src.Name)"
                            $errorCount++
                        }
                    } else {
                        Write-Warning "    [SKIP] $dest already exists"
                    }
                }
            }
        }
    }
    
    Write-Success "  [COMPLETE] Renaming finished"
    Write-Host ""
    
    # Archiving phase
    Write-Warning "  [ARCHIVING] Creating archives..."
    
    $archiveFull = "$safeName`_With_Full_Documents"
    $archivePublic = "$safeName`_With_Public_Documents"
    
    # Clean up old archives
    Remove-Item -Path "$folderPath\$archiveFull.zip" -ErrorAction SilentlyContinue
    Remove-Item -Path "$folderPath\$archiveFull.7z" -ErrorAction SilentlyContinue
    Remove-Item -Path "$folderPath\$archivePublic.zip" -ErrorAction SilentlyContinue
    Remove-Item -Path "$folderPath\$archivePublic.7z" -ErrorAction SilentlyContinue
    
    # Get current file list (re-scan to get updated names) - FIXED: Include all image types
    $allFiles = @(Get-ChildItem -Path $folderPath -File | Where-Object { 
        $_.Extension -match '\.(pdf|mp3|png|jpg|jpeg)$' -or 
        $_.Extension -match '\.(PNG|JPG|JPEG)$'
    })
    
    $publicFiles = @($allFiles | Where-Object { $_.Name -notmatch "Full_Report" })
    
    # Archive 1: Full Documents
    Write-Host "    [1/2] Creating full archive..." -ForegroundColor Blue
    try {
        if ($use7z) {
            $fileList = $allFiles | ForEach-Object { "`"$($_.FullName)`"" }
            $fileListString = $fileList -join " "
            $null = Invoke-Expression "7z a -t7z -mx=5 `"$folderPath\$archiveFull.7z`" $fileListString -y" 2>&1
            if (Test-Path "$folderPath\$archiveFull.7z") {
                Write-Success "    [OK] Created $archiveFull.7z"
                $archive1 = "$archiveFull.7z"
            } else {
                throw "7z creation failed"
            }
        } else {
            Compress-Archive -Path $allFiles.FullName -DestinationPath "$folderPath\$archiveFull.zip" -Force
            Write-Success "    [OK] Created $archiveFull.zip"
            $archive1 = "$archiveFull.zip"
        }
    } catch {
        Write-Error "    [FAIL] Could not create full archive"
        $errorCount++
    }
    
    # Archive 2: Public Documents
    Write-Host "    [2/2] Creating public archive..." -ForegroundColor Blue
    try {
        if ($use7z) {
            $fileList = $publicFiles | ForEach-Object { "`"$($_.FullName)`"" }
            $fileListString = $fileList -join " "
            $null = Invoke-Expression "7z a -t7z -mx=5 `"$folderPath\$archivePublic.7z`" $fileListString -y" 2>&1
            if (Test-Path "$folderPath\$archivePublic.7z") {
                Write-Success "    [OK] Created $archivePublic.7z"
                $archive2 = "$archivePublic.7z"
            } else {
                throw "7z creation failed"
            }
        } else {
            Compress-Archive -Path $publicFiles.FullName -DestinationPath "$folderPath\$archivePublic.zip" -Force
            Write-Success "    [OK] Created $archivePublic.zip"
            $archive2 = "$archivePublic.zip"
        }
    } catch {
        Write-Error "    [FAIL] Could not create public archive"
        $errorCount++
    }
    
    # Show archive info
    Write-Host ""
    Write-Info "  [ARCHIVES CREATED]"
    $archive1Path = Join-Path $folderPath $archive1
    $archive2Path = Join-Path $folderPath $archive2
    
    if (Test-Path $archive1Path) {
        $size1 = (Get-Item $archive1Path).Length
        $size1Formatted = Format-FileSize $size1
        Write-Success "    [1] $archive1 ($size1Formatted)"
    }
    if (Test-Path $archive2Path) {
        $size2 = (Get-Item $archive2Path).Length
        $size2Formatted = Format-FileSize $size2
        Write-Success "    [2] $archive2 ($size2Formatted)"
    }
    
    Write-Success "  [DONE] Folder processing complete"
    Write-Host ""
}

# Summary
Write-Info "==============================================================="
Write-Host "                    PROCESSING COMPLETE" -ForegroundColor White
Write-Info "==============================================================="
Write-Success "[SUCCESS] Folders processed: $processedFolders/$totalFolders"
if ($errorCount -gt 0) {
    Write-Error "[ERRORS] Total errors: $errorCount"
} else {
    Write-Success "[PERFECT] No errors encountered!"
}
Write-Host ""
Read-Host "Press Enter to exit"