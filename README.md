# C/C++ Development Setup Guide for Windows using VS Code & TDM-GCC

This guide helps you set up your Windows system to compile and run C and C++ programs using **Visual Studio Code** and the **TDM-GCC compiler**. TDM-GCC is a lightweight option, particularly suitable for systems with limited storage.

---

## ✅ Prerequisites

Before you begin, ensure you have the following:

- A Windows computer (preferably 64-bit).
- Basic knowledge of C or C++.
- **Visual Studio Code** installed.
  - 👉 [Download VS Code](https://code.visualstudio.com/)

---

## 1️⃣ Install the TDM-GCC Compiler

### 📦 Step 1: Download TDM-GCC

1.  Go to the official TDM-GCC download page:
    👉 [https://jmeubank.github.io/tdm-gcc/](https://jmeubank.github.io/tdm-gcc/)
2.  Download the recommended 64-bit installer: `tdm64-gcc-10.3.0-2.exe`

This package includes:

- `gcc` (GNU C Compiler)
- `g++` (GNU C++ Compiler)
- `gdb` (GNU Debugger)
- `mingw32-make` (optional, useful for building larger projects)
- Required runtime libraries

---

### 🧰 Step 2: Install TDM-GCC

1.  Run the downloaded `.exe` installer file.
2.  When prompted for the edition, choose **TDM-GCC 64-bit (Recommended)**.
3.  Follow the installer prompts to complete the installation. By default, it might install to a path like: `C:\TDM-GCC-64\`

---

### 🔍 Step 3: Verify GCC Installation

1.  Open **Command Prompt** (search for `cmd` in the Start menu).
2.  Type the following command and press Enter:
    ```bash
    gcc --version
    ```
3.  ✅ **Success:** You should see output displaying the GCC version (e.g., `tdm64-gcc (tdm64-1) 10.3.0`).
4.  ❌ **Failure:** If you get an error like "'gcc' is not recognized...", try restarting your PC. If it still fails, you likely need to manually add the compiler's `bin` directory to your system's PATH environment variable:
    - Search for "Environment Variables" in the Start menu and open "Edit the system environment variables".
    - Click the "Environment Variables..." button.
    - Under "System variables", find the `Path` variable, select it, and click "Edit...".
    - Click "New" and add the path to your TDM-GCC installation's `bin` folder. Default:
      ```text
      C:\TDM-GCC-64\bin
      ```
    - Click OK on all windows to save the changes.
    - **Close and reopen Command Prompt** and try `gcc --version` again.

---

## 2️⃣ Setup VS Code for C/C++

### 📦 Step 1: Install Essential VS Code Extensions

1.  Open Visual Studio Code.
2.  Go to the Extensions view (click the square icon on the left sidebar or press `Ctrl+Shift+X`).
3.  Search for and install the following extension:
    - **C/C++** (by Microsoft) - Provides IntelliSense (code completion), debugging support, and code Browse.
4.  _(Optional but Recommended)_ Install:
    - **Code Runner** (by Jun Han) - Allows quickly running code snippets or files with a simple command/shortcut (though we will set up a build task below).

---

### 🛠️ Step 2: Create Your Project Folder and File

1.  Create a new folder for your C/C++ projects, for example, `MyCProject`.
2.  Inside `MyCProject`, create your source file (e.g., `main.c`) and optionally a `.vscode` folder for configuration:
    ```text
    MyCProject/
    │
    ├── main.c           # Your C source code
    ├── build/           # Folder where compiled executables will go (created automatically)
    └── .vscode/
        └── tasks.json   # Build task configuration
    ```
3.  Create a simple C program in `main.c`:

    ```c
    #include <stdio.h>

    int main() {
        printf("Hello, World!\n");
        return 0;
    }
    ```

---

### ⚙️ Step 3: Configure the Build Task (`tasks.json`)

This task automates compiling and running your code directly from VS Code.

1.  Create a file named `tasks.json` inside the `.vscode` folder within your project directory (`MyCProject/.vscode/tasks.json`).
2.  Paste the following JSON configuration into `tasks.json`:

    ```json
    {
      "version": "2.0.0",
      "tasks": [
        {
          "label": "Compile & Run C (TDM-GCC)",
          "type": "shell",
          "command": "powershell", // Using PowerShell for multi-command sequence
          "args": [
            "-Command",
            // 1. Create 'build' directory if it doesn't exist (-Force suppresses errors if it already exists)
            "New-Item -ItemType Directory -Force -Path build;",
            // 2. Compile the current file using gcc, place output in 'build' folder
            "gcc '${file}' -o build\\${fileBasenameNoExtension}.exe;",
            // 3. If compilation ($?) was successful (exit code 0), run the compiled executable
            "if ($?) { .\\build\\${fileBasenameNoExtension}.exe }"
          ],
          "group": {
            "kind": "build",
            "isDefault": true // Makes this the default build task (Ctrl+Shift+B)
          },
          "presentation": {
            "echo": true,
            "reveal": "always", // Show the terminal panel
            "focus": false,
            "panel": "shared", // Use a shared terminal
            "showReuseMessage": false,
            "clear": false // Don't clear terminal on each run
          },
          "problemMatcher": [
            "$gcc" // Use VS Code's built-in GCC problem matcher to detect errors/warnings
          ]
        }
      ]
    }
    ```

---

## 🚀 Run Your C/C++ Code

1.  Open your C or C++ source file (e.g., `main.c`) in VS Code.
2.  Press `Ctrl + Shift + B` (the shortcut for the default build task).
3.  The integrated terminal panel will open, showing the compilation commands and then the output of your program.

---

## 🧠 Tips & Notes

- Use the `.c` file extension for C programs and `.cpp` for C++ programs.
- **For C++:** Modify the `tasks.json` command to use `g++` instead of `gcc`:
  ```powershell
  "g++ '${file}' -o build\\${fileBasenameNoExtension}.exe;"
  ```
- The `${file}` and `${fileBasenameNoExtension}` variables in `tasks.json` automatically refer to the file currently active in the editor.
- Compiled executable files (`.exe`) are placed in the `build` folder within your project directory.
- Debugging setup requires additional configuration (creating a `launch.json` file). The C/C++ extension can often help generate a basic configuration.

---

## 🧪 Example Output

After running the `main.c` example using `Ctrl + Shift + B`, you should see the following in the VS Code terminal:

```powershell
Hello, World!
```
