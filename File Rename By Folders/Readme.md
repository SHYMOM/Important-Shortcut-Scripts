<p align="center">

&nbsp; <img src="https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=for-the-badge\&logo=powershell\&logoColor=white" alt="PowerShell">

&nbsp; <img src="https://img.shields.io/badge/Windows-10%2F11-green?style=for-the-badge\&logo=windows\&logoColor=white" alt="Windows">

&nbsp; <img src="https://img.shields.io/badge/7--Zip-Optional-orange?style=for-the-badge\&logo=7zip\&logoColor=white" alt="7-Zip">

&nbsp; <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License">

</p>



<h1 align="center">🗂️ Professional File Organizer \& Archiver</h1>



<p align="center">

&nbsp; <b>Universal File Management Solution with Multi-Language Support</b><br>

&nbsp; <i>Organize • Rename • Archive • Any Language • Any Character</i>

</p>



<p align="center">

&nbsp; <a href="#-key-features">Features</a> •

&nbsp; <a href="#-whats-included">Included</a> •

&nbsp; <a href="#-quick-start-guide">Quick Start</a> •

&nbsp; <a href="#-naming-convention">Naming</a> •

&nbsp; <a href="#-system-requirements">Requirements</a> •

&nbsp; <a href="#-troubleshooting-guide">Troubleshooting</a>

</p>



---



\## 🌟 Key Features



<table>

<tr>

<td width="50%">



\### 🌍 Universal Compatibility

\- ✅ Japanese (日本語)

\- ✅ Chinese (中文)

\- ✅ Korean (한국어)

\- ✅ Arabic (العربية)

\- ✅ Russian (Русский)

\- ✅ Emoji \& Special Characters

\- ✅ Full Unicode Support



</td>

<td width="50%">



\### 🎯 Smart Organization

\- 📄 PDF Classification (Full Report / Legal / Extra)

\- 🎵 MP3 Intelligent Numbering

\- 🖼️ Image Thumbnail Management

\- 📦 Dual Archive Creation

\- 🔄 Duplicate Prevention



</td>

</tr>

</table>



---



\## 📦 What's Included



| File | Purpose | Required |

|------|---------|----------|

| `FileOrganizer.ps1` | Main PowerShell Script | ✅ Yes |

| `Run.bat` | UTF-8 Launcher | ✅ Yes |

| `README.md` | Documentation | ❌ No |



---



\## 🚀 Quick Start Guide



\### Step 1: Folder Structure



```text

Parent\_Folder/

├── FileOrganizer.ps1

├── Run.bat

├── Project\_Alpha/

│   ├── Report\_Full\_Report\_2024.pdf

│   ├── Contract\_Legal\_Document.pdf

│   ├── presentation.mp3

│   └── cover.png

├── プロジェクトベータ/

│   ├── Full\_Report\_プロジェクトベータ.pdf

│   ├── Legal\_Document\_プロジェクトベータ.pdf

│   ├── audio.mp3

│   └── thumbnail.jpg

└── 🎵 Music Project/

&nbsp;   ├── Full\_Report\_Music.pdf

&nbsp;   ├── Legal\_Document\_Music.pdf

&nbsp;   ├── song1.mp3

&nbsp;   ├── song2.mp3

&nbsp;   └── artwork.png

```



\### Step 2: Launch



Double-click `Run.bat`  

OR run:



```powershell

.\\Run.bat

```



\### Step 3: Done



The script scans folders, renames files, and creates archives automatically.



---



\# 📋 Naming Convention



\## 📄 PDF Rules



| Original | Type Detected | Output |

|----------|--------------|--------|

| Anything\_Full\_Report\_v1.pdf | Full Report | FolderName\_Full\_Report.pdf |

| Anything\_Legal\_Document.pdf | Legal | FolderName\_Legal\_Document.pdf |

| Extra\_Document.pdf | Extra | FolderName\_Document\_1.pdf |



---



\## 🎵 MP3 Rules



| Count | Result |

|-------|--------|

| 1 MP3 | FolderName.mp3 |

| 2 MP3s | FolderName.mp3 + FolderName\_Cover.mp3 |

| 3+ MP3s | Additional files numbered (\_Cover\_2, etc.) |



---



\## 🖼️ Image Rules



| Count | Result |

|-------|--------|

| 1 Image | FolderName\_Thumbnail.ext |

| 2 Images | Numbered thumbnails (\_1, \_2) |

| 3+ Images | Sequential numbering |



---



\## 🎨 Console Example



```text

\[SCAN] Found folders

\[FOUND] Full Report

\[RENAMING] Processing files

\[ARCHIVING] Creating archives

\[DONE] Folder processing complete

```



---



\## ⚙️ System Requirements



\### Minimum

\- Windows 10 / 11

\- PowerShell 5.1+

\- UTF-8 console support



\### Optional

\- 7-Zip (for .7z compression)  

&nbsp; https://www.7-zip.org/



---



\## 🔧 Manual PowerShell Execution



```powershell

\[Console]::OutputEncoding = \[System.Text.Encoding]::UTF8

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

.\\FileOrganizer.ps1

```



---



\## 📂 Supported Extensions



| Type | Extensions | Case Sensitive |

|------|------------|----------------|

| Documents | .pdf | No |

| Audio | .mp3 | No |

| Images | .png, .jpg, .jpeg | No |



---



\## 🛡️ Safety Features



\- ✅ No file deletion

\- ✅ Duplicate protection

\- ✅ Safe multi-run execution

\- ✅ Archive validation

\- ✅ Error recovery per folder



---



\## 🐛 Troubleshooting Guide



\### Cannot Access Folder

Remove forbidden characters:

```

< > : " | ? \*

```

Ensure read/write permissions.



\### Unicode Shows as ???

Change PowerShell font or use Windows Terminal.



\### Archives Not Created



```powershell

Get-ExecutionPolicy

Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

```



---



\## 📊 Example Workflow



```text

Before:

song1.mp3

song2.mp3

cover.png



After:

Album.mp3

Album\_Cover.mp3

Album\_Thumbnail.png

Album\_With\_Full\_Documents.zip

Album\_With\_Public\_Documents.zip

```



---



\## 📝 Version History



| Version | Year | Notes |

|----------|------|-------|

| 2.0 | 2024 | Full PowerShell rewrite + Unicode |

| 1.5 | 2024 | Special character fixes |

| 1.0 | 2024 | Initial batch version |



---



\## 🤝 Contributing



\- \[ ] Add RAR / TAR.GZ support

\- \[ ] GUI version (WPF / WinForms)

\- \[ ] JSON config support

\- \[ ] Multi-threading

\- \[ ] Additional image formats



---



\## 📜 License



MIT License  



Copyright (c) 2024 Professional File Organizer  



Permission is hereby granted, free of charge, to any person obtaining a copy of this software...



---



<p align="center">

&nbsp; <b>Made with ❤️ for global file organization</b><br>

&nbsp; <i>Breaking language barriers, one folder at a time</i>

</p>



<p align="center">

&nbsp; <a href="https://github.com">⭐ Star this project</a> •

&nbsp; <a href="https://github.com/issues">🐛 Report Issues</a> •

&nbsp; <a href="https://github.com/pulls">🔧 Contribute</a>

</p>

