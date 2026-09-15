# 🚀 Project Setup & Installation Guide

Welcome to **Student Marketplace**! Follow this quick and easy technical guide to get the project up and running on any Windows machine.

---

## 📋 Required Software & Downloads

Download and install the following tools before starting:

| Tool | Purpose | Download Link | Notes |
| :--- | :--- | :--- | :--- |
| **Git** | Clone repository | [git-scm.com/downloads](https://git-scm.com/downloads) | Run installer, click **Next** on all prompts. |
| **Flutter SDK** | Framework & Dart | [docs.flutter.dev/install](https://docs.flutter.dev/get-started/install/windows/mobile) | Download `.zip` and extract to `C:\flutter`. |
| **VS Code** | Code editor | [code.visualstudio.com](https://code.visualstudio.com/) | Recommended lightweight editor. |
| **Google Chrome** | Running the app | [google.com/chrome](https://www.google.com/chrome/) | Fastest way to run and test without heavy setup. |

> [!TIP]
> Inside VS Code, go to the **Extensions** tab (`Ctrl + Shift + X`), search for **Flutter**, and click **Install**.

---

## ⚙️ One-Time Setup: Add Flutter to Windows Path

To allow your terminal to recognize `flutter` commands:

1. Press the **Windows Key**, type `env`, and open **"Edit the system environment variables"**.
2. Click **Environment Variables...** at the bottom.
3. Under **User variables**, select **`Path`** and click **Edit...**.
4. Click **New**, type:
   ```text
   C:\flutter\bin
   ```
5. Click **OK** on all windows to save.

> [!NOTE]
> Open a new Command Prompt or Terminal and type `flutter --version` to confirm it is working.

---

## 💻 Clone & Run the Project

Open **Command Prompt**, **PowerShell**, or the built-in **VS Code Terminal**, and execute these commands step by step:

### Step 1: Clone the Repository
```bash
git clone https://github.com/Hasnath007/Student_Marketplace_.git
```

### Step 2: Navigate into the Project Folder
```bash
cd Student_Marketplace_
```

### Step 3: Verify Setup
```bash
flutter doctor
```
*(Ensure Flutter and Chrome show green checkmarks).*

### Step 4: Install Dependencies
```bash
flutter pub get
```

### Step 5: Start the Application

* **Run on Chrome (Recommended):**
  ```bash
  flutter run -d chrome
  ```

* **Run on Android (Phone / Emulator):**
  ```bash
  flutter run
  ```

* **Run on Windows Desktop:**
  ```bash
  flutter run -d windows
  ```

---

## 🛠️ Common Quick Fixes

* **Missing Android Licenses?**
  Run: `flutter doctor --android-licenses` and type `y` to accept all prompts.
* **Packages out of sync or build cache issue?**
  Run: `flutter clean` followed by `flutter pub get`.
* **See all connected devices:**
  Run: `flutter devices`.
