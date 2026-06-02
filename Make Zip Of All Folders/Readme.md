# Folder Processor & Image Extractor

A lightweight Windows Batch script that automates the process of organizing, renaming, and archiving folders. It is designed to run in a parent directory, process all subdirectories within it, extract images, and package the folders into `.zip` files.

## 🚀 Features

* **Smart Renaming:** Scans every subfolder and renames all files inside to match the parent folder's name, appending a sequential number to prevent overwriting (e.g., `FolderName_1.txt`, `FolderName_2.jpg`).
* **Image Extraction:** Automatically detects standard image formats (`.jpg`, `.jpeg`, `.png`, `.gif`) from inside the subfolders and safely copies them to the root directory where the script is located.
* **Auto-Zipping:** Uses native Windows PowerShell to seamlessly compress each processed subfolder into its own `.zip` archive.

## 📋 Prerequisites

* **OS:** Windows 10 or Windows 11.
* **Requirements:** Windows PowerShell (built into modern Windows by default). No third-party software like WinRAR or 7-Zip is required.

## 🛠️ Installation & Setup

1. Create a new text document in your desired root folder.
2. Open the document and paste the script code into it.
3. Go to **File > Save As**.
4. In the "Save as type" dropdown menu, select **All Files (*.*)**.
5. Name the file `ProcessFolders.bat` (or any name you prefer, as long as it ends in `.bat`).
6. Save the file. You can now delete the original text document.

## 💻 Usage

1. Place `ProcessFolders.bat` in the **parent directory** containing the folders you want to process.
2. Double-click `ProcessFolders.bat` to run it.
3. A command prompt window will appear, detailing the progress as it processes each folder.
4. Press any key to close the window once it says "All tasks completed successfully!".

### Example Directory Structure

**Before running the script:**
```text
C:\MyProjects\
 ├── ProcessFolders.bat
 ├── Project Alpha\
 │    ├── logo.png
 │    └── notes.txt
 └── Project Beta\
      ├── background.jpg
      └── data.csv
```

**After running the script:**
```text
C:\MyProjects\
 ├── ProcessFolders.bat
 ├── Project Alpha_1.png     <-- Extracted image
 ├── Project Beta_1.jpg      <-- Extracted image
 ├── Project Alpha.zip       <-- Zipped folder
 ├── Project Beta.zip        <-- Zipped folder
 ├── Project Alpha\
 │    ├── Project Alpha_1.png
 │    └── Project Alpha_2.txt
 └── Project Beta\
      ├── Project Beta_1.jpg
      └── Project Beta_2.csv
```

## ⚠️ Important Notes

* **One-Way Operation:** Renaming files is permanent. It is highly recommended to test this script on a backup copy of your folders first to ensure it behaves exactly as you want.
* **Empty Folders:** If a folder is empty, the script will still attempt to zip it, resulting in an empty `.zip` file.
* **Image Overwrites:** If multiple folders have identically named extracted images (e.g., if you run the script multiple times without cleaning up), Windows will overwrite the older copies in the root directory.