# Git Cheatsheet 📚

Quick reference for history rewriting + comprehensive Git command guide.

---

## ✏️ History Rewriting Quick Reference

### Amending Commits

```bash
# Change last commit message
git commit --amend
git commit --amend -m "New message"

# Add forgotten files to last commit
git add forgotten-file.txt
git commit --amend --no-edit

# Change author of last commit
git commit --amend --author="Name <email@example.com>"
git commit --amend --reset-author

# Change commit date
git commit --amend --date="2024-01-01 12:00:00"
```

### Reset Operations

```bash
# Soft reset (keep changes staged)
git reset --soft HEAD~1
git reset --soft abc123

# Mixed reset (unstage changes, keep in working dir)
git reset HEAD~1
git reset --mixed abc123

# Hard reset (DISCARD all changes!)
git reset --hard HEAD~1
git reset --hard abc123

# Reset specific file
git reset HEAD <file>
git restore --staged <file>
```

### Reverting Changes

```bash
# Revert last commit (safe, creates new commit)
git revert HEAD

# Revert specific commit
git revert abc123

# Revert multiple commits
git revert HEAD~3..HEAD
git revert --no-commit HEAD~3..HEAD
git commit

# Revert merge commit (must specify parent)
git revert -m 1 <merge-commit-sha>

# Abort revert
git revert --abort

# Continue after resolving conflicts
git revert --continue
```

### Filter-Branch & Filter-Repo

```bash
# Remove file from all history (filter-branch - old method)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/file" \
  --prune-empty --tag-name-filter cat -- --all

# Remove file (filter-repo - recommended)
git filter-repo --path path/to/file --invert-paths

# Change author email
git filter-branch --env-filter '
if [ "$GIT_AUTHOR_EMAIL" = "old@example.com" ]; then
    export GIT_AUTHOR_EMAIL="new@example.com"
    export GIT_COMMITTER_EMAIL="new@example.com"
fi
' -- --all

# Remove directory
git filter-repo --path dir/to/remove/ --invert-paths

# Clean up after filter
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

### Recovery & Reflog

```bash
# View reflog (all HEAD movements)
git reflog
git reflog show <branch>

# Recover lost commits
git reset --hard HEAD@{5}
git reset --hard abc123

# View reflog with dates
git reflog --date=iso

# Cherry-pick from reflog
git cherry-pick HEAD@{3}

# Expire reflog entries
git reflog expire --expire=30.days --all

# Reflog for specific file
git log --all --full-history -- path/to/file
```

### Repository Cleanup

```bash
# Delete local branch
git branch -d <branch>      # Safe (merged only)
git branch -D <branch>      # Force (unmerged too)

# Delete remote branch
git push origin --delete <branch>

# Prune remote-tracking branches
git fetch --prune
git remote prune origin

# Garbage collection
git gc
git gc --aggressive --prune=now

# Remove untracked files
git clean -n                # Dry run
git clean -f                # Remove files
git clean -fd               # Remove files and directories
git clean -fx               # Include ignored files

# Verify repository
git fsck
git fsck --full

# Count objects
git count-objects -v
git count-objects -vH       # Human readable
```

### Safety & Backup

```bash
# Create backup branch before dangerous ops
git branch backup-before-changes
git tag backup-tag-$(date +%Y%m%d)

# Create bundle (portable backup)
git bundle create repo.bundle --all

# Restore from bundle
git clone repo.bundle restored-repo

# Export patches
git format-patch HEAD~3
git format-patch master --stdout > changes.patch

# Apply patches
git am < patch-file
git apply changes.patch
```

---

## 📖 Comprehensive Git Command Reference

[Same comprehensive reference as repo 03, including all sections:]

### Initial Setup & Configuration
### Creating & Cloning Repositories
### Checking Repository Status
### Staging Changes
### Committing Changes
### Viewing Changes
### Undoing Changes
### Branching
### Merging
### Remote Repositories
### Tagging
### Stashing
### Cherry-Picking
### Viewing & Searching
### History & Cleanup
### .gitignore
### Useful Aliases
### Advanced Commands
### Pro Tips

[Full content from repo 03's comprehensive reference - omitted here for brevity but would be identical]

---

## 🔐 History Rewriting Safety Guidelines

### When Rewriting is Safe ✅

```bash
# Local commits not pushed
git log origin/master..HEAD  # Shows unpushed commits
git rebase -i HEAD~3         # Safe to rewrite these

# Private feature branches
git branch --no-merged       # Check which branches
git rebase master            # Safe if you own branch

# Before creating pull request
git rebase -i master         # Clean up before PR
git push --force-with-lease origin feature
```

### When to Avoid Rewriting ❌

```bash
# ❌ Master/main branch
git reset --hard HEAD~5      # DON'T on master

# ❌ Shared feature branches
git rebase master            # DON'T if others are using

# ❌ Released commits
git tag v1.0.0
git reset --hard HEAD~1      # DON'T rewrite tags

# ❌ Commits others based work on
git log --all --graph        # Check dependencies first
```

### Recovery Checklist

```bash
# 1. Check reflog
git reflog

# 2. Find commit before mistake
git log HEAD@{1}

# 3. Reset to that commit
git reset --hard HEAD@{1}

# 4. Or cherry-pick if needed
git cherry-pick abc123

# 5. Create recovery branch
git branch recovered HEAD@{5}
```

---

## ⚠️ Danger Zone Commands

These commands can cause data loss. Use with extreme caution!

```bash
# DANGER: Hard reset (loses changes)
git reset --hard HEAD~5

# DANGER: Force push (overwrites remote)
git push --force origin master

# DANGER: Filter-branch (rewrites all history)
git filter-branch --force --index-filter "..." -- --all

# DANGER: Clean with ignored files
git clean -fdx

# DANGER: Delete unmerged branch
git branch -D feature-branch

# SAFER ALTERNATIVES:
git reset --soft HEAD~5                    # Instead of --hard
git push --force-with-lease origin master  # Instead of --force
git filter-repo ...                        # Instead of filter-branch
git clean -n                               # Dry run first
git branch -d feature-branch               # Safe delete
```

---

## 📊 Comparison Tables

### Reset Types

| Type | HEAD | Index (Staging) | Working Directory | Use Case |
|------|------|-----------------|-------------------|----------|
| `--soft` | ✅ Moved | ❌ Unchanged | ❌ Unchanged | Recommit with changes |
| `--mixed` | ✅ Moved | ✅ Reset | ❌ Unchanged | Unstage files |
| `--hard` | ✅ Moved | ✅ Reset | ✅ Reset | Discard everything |

### Revert vs Reset

| Feature | Revert | Reset |
|---------|--------|-------|
| History | Preserves (adds commit) | Rewrites (removes commits) |
| Safety | Safe for public branches | Dangerous for public branches |
| Undo | Creates inverse commit | Removes commits |
| Force Push | Never needed | Often needed |
| Team Impact | No impact | Breaks others' work |

### Amend vs Interactive Rebase

| Feature | Amend | Interactive Rebase |
|---------|-------|-------------------|
| Commits | Last one only | Multiple commits |
| Operations | Add files, change message | Squash, reorder, edit, drop |
| Complexity | Simple | Complex |
| Conflicts | Rare | Possible |
| Use Case | Quick fixes | Major cleanup |

---

## 🛠️ Workflow Patterns

### Fix Last Commit Workflow

```bash
# Scenario: Forgot to add file
git add forgotten-file.txt
git commit --amend --no-edit

# Scenario: Typo in message
git commit --amend -m "Fixed message"

# Scenario: Wrong author
git commit --amend --author="Correct Name <email@example.com>"
```

### Undo Commits Workflow

```bash
# If not pushed yet: reset
git reset --soft HEAD~2
git commit -m "Combined commit"

# If pushed: revert
git revert HEAD~2..HEAD
git push origin master
```

### Remove Sensitive Data Workflow

```bash
# 1. Create backup
git branch backup

# 2. Remove from history
git filter-repo --path secrets.txt --invert-paths

# 3. Clean up
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# 4. Force push (coordinate with team!)
git push --force --all
git push --force --tags
```

### Cleanup Old Branches Workflow

```bash
# 1. See merged branches
git branch --merged master

# 2. Delete locally
git branch -d old-feature

# 3. Delete remotely
git push origin --delete old-feature

# 4. Prune remote refs
git fetch --prune
```

---

## 📚 Additional Resources

- [Git Reset Documentation](https://git-scm.com/docs/git-reset)
- [Git Revert Documentation](https://git-scm.com/docs/git-revert)
- [Git Filter-Repo](https://github.com/newren/git-filter-repo)
- [Oh Shit, Git!?!](https://ohshitgit.com/)
- [Pro Git Book - Rewriting History](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History)

---

**Use history rewriting powers responsibly! 🦸**
