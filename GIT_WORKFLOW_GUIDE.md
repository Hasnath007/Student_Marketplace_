# Git Workflow & Collaboration Technical Guide

## 1. Executive Summary
This technical document outlines the standard Git workflow for version control, branch management, remote synchronization (`git pull`), and publishing changes (`git push`) to GitHub. Following this workflow prevents merge conflicts, lost work, and inconsistent commit histories across the team.

---

## 2. Branch Management: How to Switch & Create Branches

A Git branch represents an independent line of development. You should never commit directly to production branches (`main` or `master`).

### 2.1 Inspecting Existing Branches
Before switching, check which branch you are currently on:
```bash
# List local branches (* indicates current active branch)
git branch

# List all local and remote tracking branches
git branch -a
```

### 2.2 Switching to an Existing Local Branch
Use `git switch` (the modern Git 2.23+ command) or `git checkout`:
```bash
# Modern syntax (Recommended)
git switch <branch-name>

# Traditional syntax
git checkout <branch-name>
```
*Example:*
```bash
git switch main
```

### 2.3 Switching to a Remote Branch Not Yet Present Locally
If a teammate created a branch on GitHub (e.g. `feature/user-auth`) that is not yet on your machine:
```bash
# 1. Fetch all latest remote branches and commits
git fetch origin

# 2. Switch to the branch (Git automatically creates a local tracking branch)
git switch <branch-name>
```

### 2.4 Creating and Switching to a New Branch
Always base your new branch off the latest version of your primary branch (`main` or `develop`):
```bash
# 1. Switch to base branch and pull latest updates
git switch main
git pull origin main

# 2. Create and switch to the new feature branch in one command
git switch -c feature/marketplace-chat

# Alternatively using legacy syntax:
# git checkout -b feature/marketplace-chat
```

### 2.5 What to Do if Uncommitted Changes Block Branch Switching
If Git prevents you from switching because of uncommitted local edits:
- **Option A: Stash your changes temporarily (Recommended)**
  ```bash
  git stash save "WIP: temporary changes"
  git switch <target-branch>
  
  # When you return to your original branch later:
  git stash pop
  ```
- **Option B: Commit your changes before switching**
  ```bash
  git add .
  git commit -m "wip: save current progress"
  git switch <target-branch>
  ```

---

## 3. Remote Synchronization: When and How to `git pull`

### 3.1 What `git pull` Does Under the Hood
`git pull` performs two sequential actions:
1. `git fetch`: Downloads new commits, branches, and tags from GitHub without modifying your local working files.
2. `git merge`: Merges those downloaded changes into your currently active local branch.

---

### 3.2 Exactly WHEN Should You Run `git pull`?

| Trigger / Scenario | Purpose | Command |
| :--- | :--- | :--- |
| **1. Starting your workday / work session** | Ensures you are building on the freshest codebase. | `git switch main && git pull` |
| **2. Before creating any new branch** | Guarantees your new branch starts from the most up-to-date state. | `git switch main && git pull` |
| **3. Before pushing your branch or opening a PR** | Pull the latest `main` into your branch to catch and resolve merge conflicts locally. | `git pull origin main` |
| **4. When a teammate pushes updates to your shared branch** | Synchronizes changes made by collaborators. | `git pull` |

> **Important Rule:**
> Avoid running `git pull` when you have unstaged or dirty changes that conflict with remote changes. Either commit or stash (`git stash`) them first.

### 3.3 Recommended Practice: `git pull --rebase`
By default, standard `git pull` generates a cluttering "Merge branch..." commit if your local branch has diverged slightly. To keep a clean, linear commit history, use rebase:
```bash
git pull --rebase origin <branch-name>
```
You can configure Git to always rebase on pull:
```bash
git config --global pull.rebase true
```

---

## 4. Publishing Changes: How to Push to GitHub

Pushing transfers your committed local changes to the remote GitHub repository.

### Step-by-Step Push Workflow

#### Step 1: Check Current Status
Verify modified, created, or deleted files:
```bash
git status
```

#### Step 2: Stage Files for Commit
Stage specific files or all modified files:
```bash
# Stage specific files (Best Practice)
git add lib/features/marketplace/screens/product_details_screen.dart

# Or stage all tracked and untracked changes
git add .
```

#### Step 3: Create a Meaningful Commit
Follow Conventional Commits standards (`feat:`, `fix:`, `refactor:`, `docs:`):
```bash
git commit -m "feat: add direct seller chat button on product details screen"
```

#### Step 4: Push to GitHub

##### Case A: First Time Pushing a Newly Created Branch
If the branch does not exist on GitHub yet, set the upstream tracking branch using `-u` (or `--set-upstream`):
```bash
git push -u origin <your-branch-name>
```
*Example:*
```bash
git push -u origin feature/marketplace-chat
```
*Why `-u`?* This tells Git to bind your local branch to `origin/feature/marketplace-chat`. For all future pushes on this branch, you only need to run `git push`.

##### Case B: Subsequent Pushes on an Existing Branch
Once upstream is set:
```bash
git push
```

> **Warning:**
> Avoid using `git push --force` on shared or production branches. Overwriting remote history can erase your teammates' work. If you must update a personal PR branch after a rebase, use the safer alternative:
> `git push --force-with-lease`

---

## 5. End-to-End Daily Development Cycle (Cheatsheet)

Follow this standard flow for every feature or bug fix:

```text
[Start Task]
     │
     ▼
[Switch to 'main' & git pull]
     │
     ▼
[git switch -c feature/your-feature]
     │
     ▼
[Write Code & Run Tests]
     │
     ▼
[git status & git add .]
     │
     ▼
[git commit -m "feat: description"]
     │
     ▼
[git fetch origin & git merge origin/main]  <-- Resolve any conflicts
     │
     ▼
[git push -u origin feature/your-feature]
     │
     ▼
[Open Pull Request (PR) on GitHub]
```

### Complete Terminal Command Sequence
```bash
# 1. Start from latest main
git switch main
git pull origin main

# 2. Create feature branch
git switch -c feature/item-filters

# 3. Code your changes, then review diff
git status
git diff

# 4. Stage & Commit
git add .
git commit -m "feat(marketplace): implement category and price filter widgets"

# 5. Bring in any changes that were merged into main while you were working
git fetch origin
git merge origin/main
# (Resolve any conflicts if prompted, then commit)

# 6. Push branch to GitHub
git push -u origin feature/item-filters

# 7. Create Pull Request on GitHub
```

---

## 6. Common Errors & Quick Solutions

### Issue 1: "Updates were rejected because the remote contains work that you do not have locally"
- **Cause:** Someone else pushed commits to the remote branch, or you committed via the GitHub web editor.
- **Solution:** Pull the remote commits first, then push:
  ```bash
  git pull --rebase origin <branch-name>
  git push origin <branch-name>
  ```

### Issue 2: Committed to the wrong branch (e.g. accidentally committed to `main`)
- **Solution (if not yet pushed to GitHub):**
  ```bash
  # 1. Create a new branch carrying over your recent commit
  git branch feature/my-feature

  # 2. Reset local main back by one commit
  git reset --hard HEAD~1

  # 3. Switch to your new branch
  git switch feature/my-feature
  ```

### Issue 3: Undo the last commit (keep your code modifications intact)
- **Solution:**
  ```bash
  # Undoes commit but keeps all changes in your working directory
  git reset --soft HEAD~1
  ```
