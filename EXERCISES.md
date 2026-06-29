# History Rewriting - Exercises ✏️

15 hands-on exercises to master Git history rewriting safely.

## Exercise Format

Each exercise includes:
- **Objective**: What you'll learn
- **Scenario**: The problem setup
- **Tasks**: Step-by-step instructions
- **Validation**: How to verify success
- **Learning Points**: Key takeaways

---

## 🟢 Amending Commits (Exercises 1-3)

### Exercise 1: Fix Last Commit Message

**Objective**: Learn to amend commit messages

**Scenario**: You just committed but noticed a typo in the commit message.

**Tasks**:
1. Check recent commits:
   ```bash
   git log --oneline -n 5
   # Look for commit with typo
   ```

2. Amend the last commit message:
   ```bash
   git commit --amend
   # Editor opens, fix the message
   # Save and close
   ```

3. Amend with command-line message (faster):
   ```bash
   git commit --amend -m "Corrected commit message"
   ```

4. View updated history:
   ```bash
   git log --oneline -n 5
   # Should see new message
   ```

**Validation**:
```bash
# Check last commit message
git log -1 --pretty=%B
# Should show corrected message

# Check commit SHA changed
git log --oneline -n 2
# SHA of last commit is different
```

**Learning Points**:
- ✅ `--amend` replaces last commit
- ✅ Creates new SHA (rewrites history)
- ✅ Only use if commit not pushed
- ✅ Can also add forgotten files

---

### Exercise 2: Add Forgotten Files to Last Commit

**Objective**: Include files you forgot to stage

**Scenario**: You committed but forgot to add a file that should be in that commit.

**Tasks**:
1. Find the incomplete commit:
   ```bash
   git log --oneline -n 3
   git show HEAD  # Check what's in last commit
   ```

2. Create/modify the forgotten file:
   ```bash
   # (File should already exist from build-history.sh)
   echo "// Additional functionality" >> src/store.js
   ```

3. Stage the forgotten file:
   ```bash
   git add src/store.js
   ```

4. Amend commit to include it:
   ```bash
   git commit --amend --no-edit
   # Keeps same message, adds new files
   ```

5. Verify file is in commit:
   ```bash
   git show HEAD
   # Should show changes to src/store.js
   ```

**Validation**:
```bash
# Check files in last commit
git diff-tree --no-commit-id --name-only -r HEAD
# Should include src/store.js

# View commit details
git show HEAD --stat
```

**Learning Points**:
- ✅ Stage files first, then amend
- ✅ `--no-edit` keeps current message
- ✅ Can amend message AND files together
- ✅ Great for "oops forgot to add..."

---

### Exercise 3: Change Author of Last Commit

**Objective**: Fix commit authorship

**Scenario**: You committed with wrong Git identity configured.

**Tasks**:
1. Check current author:
   ```bash
   git log -1 --pretty=format:"%an <%ae>"
   ```

2. Amend with correct author:
   ```bash
   git commit --amend --author="Your Name <your.email@example.com>"
   # Or:
   git commit --amend --reset-author
   # Uses current git config
   ```

3. Verify change:
   ```bash
   git log -1 --pretty=format:"%an <%ae> - %s"
   ```

**Validation**:
```bash
# Check author details
git log -1 --format=fuller
# Should show correct author and committer
```

**Learning Points**:
- ✅ `--author` sets specific author
- ✅ `--reset-author` uses current config
- ✅ Author ≠ Committer (usually same)
- ✅ Useful when pair programming

---

## 🟡 Reset Operations (Exercises 4-7)

### Exercise 4: Soft Reset (Undo Commit, Keep Changes)

**Objective**: Understand `git reset --soft`

**Scenario**: You want to undo last commit but keep all changes staged.

**Tasks**:
1. Check current state:
   ```bash
   git log --oneline -n 3
   git status
   ```

2. Soft reset to previous commit:
   ```bash
   git reset --soft HEAD~1
   ```

3. Check status:
   ```bash
   git status
   # Changes are staged
   
   git log --oneline -n 3
   # Last commit is gone
   ```

4. View what's staged:
   ```bash
   git diff --staged
   # Shows changes that were in undone commit
   ```

**Validation**:
```bash
# Working directory clean, staging has changes
git status
# Should show "Changes to be committed"

# Can re-commit now
git commit -m "Re-commit with changes"
```

**Learning Points**:
- ✅ `--soft` only moves HEAD
- ✅ Keeps changes in staging area
- ✅ Great for re-committing with changes
- ✅ Safest reset option

---

### Exercise 5: Mixed Reset (Undo Commit and Staging)

**Objective**: Understand `git reset --mixed` (default)

**Scenario**: You want to undo commit and unstage changes.

**Tasks**:
1. Check current state:
   ```bash
   git log --oneline -n 3
   ```

2. Mixed reset (default behavior):
   ```bash
   git reset HEAD~1
   # Same as: git reset --mixed HEAD~1
   ```

3. Check status:
   ```bash
   git status
   # Changes are unstaged
   
   git diff
   # Shows changes in working directory
   ```

4. Files still exist:
   ```bash
   ls src/
   # All files present, just not staged
   ```

**Validation**:
```bash
# Changes in working directory, not staged
git status
# Should show "Changes not staged for commit"

# Can selectively stage now
git add src/products.js
git commit -m "Add just products module"
```

**Learning Points**:
- ✅ `--mixed` is default reset
- ✅ Moves HEAD and resets staging
- ✅ Keeps working directory changes
- ✅ Useful for reorganizing commits

---

### Exercise 6: Hard Reset (Discard Everything)

**Objective**: Understand `git reset --hard` (DANGER!)

**Scenario**: You want to completely discard recent commits and changes.

**Tasks**:
1. **⚠️ CREATE BACKUP FIRST!**
   ```bash
   git branch backup-before-hard-reset
   ```

2. Check what you're about to lose:
   ```bash
   git log --oneline -n 5
   git diff HEAD~2
   ```

3. Hard reset (destroys changes):
   ```bash
   git reset --hard HEAD~2
   # Goes back 2 commits, discards all changes
   ```

4. Verify everything is gone:
   ```bash
   git status
   # Clean working directory
   
   git log --oneline -n 5
   # Last 2 commits gone
   ```

5. **Recovery if needed**:
   ```bash
   # If you made a mistake:
   git reflog
   git reset --hard HEAD@{1}
   # Or: git reset --hard backup-before-hard-reset
   ```

**Validation**:
```bash
# Clean working directory
git status
# Should be clean

# History shortened
git log --oneline
# Should show fewer commits
```

**Learning Points**:
- ✅ `--hard` is DESTRUCTIVE
- ✅ Always create backup branch first
- ✅ Can recover with reflog
- ✅ Use when you're sure you want to discard

---

### Exercise 7: Reset to Specific Commit

**Objective**: Reset to any commit in history

**Scenario**: You need to reset to a specific commit, not just HEAD~N.

**Tasks**:
1. Find target commit:
   ```bash
   git log --oneline
   # Find SHA of commit you want
   # Example: abc123 Add checkout feature
   ```

2. Reset to that commit:
   ```bash
   git reset --hard abc123
   # Or any SHA
   ```

3. Alternative: Reset by searching:
   ```bash
   # Find commit by message
   git log --grep="checkout" --oneline
   
   # Reset to that commit
   git reset --hard <commit-sha>
   ```

**Validation**:
```bash
# Verify at correct commit
git log --oneline -n 1
# Should show target commit

# Check reflog for recovery
git reflog
# Can go back if needed
```

**Learning Points**:
- ✅ Can reset to any commit SHA
- ✅ Not limited to HEAD~N syntax
- ✅ Use `git log` to find target
- ✅ Reflog always tracks resets

---

## 🔵 Reverting Changes (Exercises 8-10)

### Exercise 8: Revert Last Commit

**Objective**: Safely undo a commit without rewriting history

**Scenario**: You need to undo a commit that's already pushed/shared.

**Tasks**:
1. Check what needs reverting:
   ```bash
   git log --oneline -n 3
   git show HEAD
   ```

2. Revert the last commit:
   ```bash
   git revert HEAD
   # Editor opens for revert message
   # Default message is fine, save and close
   ```

3. View result:
   ```bash
   git log --oneline -n 2
   # Shows original commit + revert commit
   
   git show HEAD
   # Shows changes that undo previous commit
   ```

**Validation**:
```bash
# Should have new commit
git log --oneline -n 3
# Example:
# def456 Revert "Add feature X"
# abc123 Add feature X
# ghi789 Previous commit

# Changes are undone
git diff HEAD~2 HEAD
# Should show net zero changes
```

**Learning Points**:
- ✅ Revert creates new commit
- ✅ Doesn't rewrite history (safe!)
- ✅ Use for public/shared commits
- ✅ Better than reset for collaboration

---

### Exercise 9: Revert Multiple Commits

**Objective**: Revert a range of commits

**Scenario**: Multiple commits need to be undone.

**Tasks**:
1. Identify commit range:
   ```bash
   git log --oneline -n 10
   # Want to revert HEAD~4 through HEAD
   ```

2. Revert range (oldest to newest):
   ```bash
   git revert HEAD~4..HEAD
   # Or:
   git revert --no-commit HEAD~4..HEAD
   git commit -m "Revert multiple changes"
   ```

3. Revert each individually:
   ```bash
   # Alternative: revert one by one
   git revert HEAD
   git revert HEAD~1
   git revert HEAD~2
   # etc.
   ```

**Validation**:
```bash
# Should have revert commits
git log --oneline -n 8

# Net changes cancelled out
git diff HEAD~8 HEAD
```

**Learning Points**:
- ✅ Can revert ranges
- ✅ `--no-commit` combines into one revert
- ✅ Order matters (oldest..newest)
- ✅ May have conflicts to resolve

---

### Exercise 10: Revert a Merge Commit

**Objective**: Revert a merge (requires -m parent number)

**Scenario**: A merge introduced bugs, need to revert it.

**Tasks**:
1. Find merge commit:
   ```bash
   git log --merges --oneline
   # Find merge commit SHA
   ```

2. View merge commit details:
   ```bash
   git show <merge-commit-sha>
   # Shows merge has 2 parents
   ```

3. Revert merge (specify parent):
   ```bash
   git revert -m 1 <merge-commit-sha>
   # -m 1 = keep first parent (usually master)
   # -m 2 = keep second parent (usually feature)
   ```

4. View result:
   ```bash
   git log --oneline -n 3
   ```

**Validation**:
```bash
# Should have revert of merge
git log --oneline --merges -n 2

# Check history
git log --oneline --graph -n 10
```

**Learning Points**:
- ✅ Merge commits have 2+ parents
- ✅ Must specify which parent to keep (-m)
- ✅ -m 1 usually means keep mainline
- ✅ Can re-merge later if needed

---

## 🟣 Filter Operations (Exercises 11-13)

### Exercise 11: Remove File from All History

**Objective**: Completely remove file from Git history

**Scenario**: Accidentally committed a secret file, need to remove it everywhere.

**Tasks**:
1. **⚠️ DANGER: This rewrites all history! Create backup!**
   ```bash
   git branch backup-before-filter
   ```

2. Check file exists in history:
   ```bash
   git log --all --oneline -- src/secrets.txt
   # Should show commits with this file
   ```

3. Remove file from all history (old method):
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch src/secrets.txt" \
     --prune-empty --tag-name-filter cat -- --all
   ```

4. Better: Use git-filter-repo (if installed):
   ```bash
   # Install: pip install git-filter-repo
   git filter-repo --path src/secrets.txt --invert-paths
   ```

5. Clean up:
   ```bash
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   ```

**Validation**:
```bash
# File should not exist in history
git log --all --oneline -- src/secrets.txt
# Empty output

# File should not exist in any commit
git rev-list --all | while read commit; do
    git ls-tree -r $commit | grep secrets.txt && echo "Found in $commit"
done
# Should find nothing
```

**Learning Points**:
- ✅ filter-branch rewrites ALL history
- ✅ ALL SHAs change
- ✅ Requires force-push if already pushed
- ✅ Notify collaborators!
- ✅ `git-filter-repo` is recommended modern tool

---

### Exercise 12: Change Author Email in History

**Objective**: Fix authorship across multiple commits

**Scenario**: You committed with wrong email, need to fix all instances.

**Tasks**:
1. Find commits with wrong email:
   ```bash
   git log --author="wrong@example.com" --oneline
   ```

2. Change author email (filter-branch):
   ```bash
   git filter-branch --env-filter '
   if [ "$GIT_AUTHOR_EMAIL" = "wrong@example.com" ]; then
       export GIT_AUTHOR_EMAIL="correct@example.com"
       export GIT_COMMITTER_EMAIL="correct@example.com"
   fi
   ' --tag-name-filter cat -- --all
   ```

3. Verify change:
   ```bash
   git log --author="correct@example.com" --oneline
   # Should show previously wrong commits
   ```

**Validation**:
```bash
# No more wrong email
git log --author="wrong@example.com" --oneline
# Should be empty

# Check specific commits
git log --format="%an <%ae>" --oneline
```

**Learning Points**:
- ✅ `--env-filter` modifies commit metadata
- ✅ Can change author, committer, dates
- ✅ Useful for corporate email changes
- ✅ Rewrites all affected commits

---

### Exercise 13: Remove Large Files from History

**Objective**: Clean up accidentally committed large files

**Scenario**: You committed large binaries that bloat the repository.

**Tasks**:
1. Find large files:
   ```bash
   git rev-list --objects --all | \
   git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
   awk '/^blob/ {print substr($0,6)}' | \
   sort --numeric-sort --key=2 | \
   tail -n 10
   ```

2. Remove large file:
   ```bash
   # If file is large-file.bin:
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch large-file.bin" \
     --prune-empty --tag-name-filter cat -- --all
   ```

3. Clean up repository:
   ```bash
   rm -rf .git/refs/original/
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   ```

4. Check repository size:
   ```bash
   du -sh .git/
   # Should be smaller
   ```

**Validation**:
```bash
# File gone from history
git log --all -- large-file.bin
# Empty

# Repository size reduced
git count-objects -vH
```

**Learning Points**:
- ✅ Large files bloat repository forever
- ✅ Must remove from history to reclaim space
- ✅ gc is needed to actually free space
- ✅ Consider Git LFS for large files

---

## 🔴 Recovery & Cleanup (Exercises 14-15)

### Exercise 14: Recover Lost Commits

**Objective**: Use reflog to recover "lost" commits

**Scenario**: You did a hard reset and lost important commits.

**Tasks**:
1. Simulate losing commits:
   ```bash
   git log --oneline -n 5
   # Note SHA of current HEAD
   
   git reset --hard HEAD~3
   # Commits are "lost"
   ```

2. View reflog (your safety net):
   ```bash
   git reflog
   # Shows all HEAD movements
   ```

3. Find lost commit:
   ```bash
   git reflog | grep "commit: Add important feature"
   # Example output: abc123 HEAD@{5}: commit: Add important feature
   ```

4. Recover lost commit:
   ```bash
   git reset --hard HEAD@{5}
   # Or: git reset --hard abc123
   ```

5. Verify recovery:
   ```bash
   git log --oneline -n 5
   # Commits are back!
   ```

**Validation**:
```bash
# History restored
git log --oneline
# Should show recovered commits

# Can also cherry-pick if needed
git cherry-pick abc123
```

**Learning Points**:
- ✅ Reflog tracks all HEAD movements
- ✅ Commits aren't truly lost for ~90 days
- ✅ Can recover from resets, rebases, etc.
- ✅ `HEAD@{n}` refers to reflog entries

---

### Exercise 15: Clean Up Local Branches

**Objective**: Remove old branches and clean up repository

**Scenario**: Repository has many old local branches to clean up.

**Tasks**:
1. List all local branches:
   ```bash
   git branch
   ```

2. Check which branches are merged:
   ```bash
   git branch --merged master
   # Safe to delete these
   ```

3. Delete merged branches:
   ```bash
   git branch -d feature/old-branch
   # Or bulk delete:
   git branch --merged | grep -v "\*" | grep -v "master" | xargs -n 1 git branch -d
   ```

4. Force delete unmerged branch (if needed):
   ```bash
   git branch -D feature/abandoned
   # Use with caution!
   ```

5. Clean up remote-tracking branches:
   ```bash
   git fetch --prune
   # Removes remote branches that no longer exist
   ```

6. Full cleanup:
   ```bash
   git gc --aggressive --prune=now
   # Optimize repository
   ```

**Validation**:
```bash
# Fewer branches
git branch
# Should show only active branches

# Repository optimized
git count-objects -vH
```

**Learning Points**:
- ✅ `-d` safe delete (merged only)
- ✅ `-D` force delete (unmerged)
- ✅ `--prune` removes stale remote refs
- ✅ Regular cleanup keeps repo healthy

---

## 🎉 Completion

Congratulations! You've mastered Git history rewriting!

### What You've Learned:
- ✅ Amending commits safely
- ✅ Reset (soft, mixed, hard)
- ✅ Reverting changes
- ✅ Filter operations
- ✅ Recovery techniques
- ✅ Repository cleanup

### Next Steps:
1. Review [SOLUTIONS.md](./SOLUTIONS.md) for detailed explanations
2. Read [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for recovery techniques
3. Take the quiz in `../git-mastery-quiz/`
4. Move to [Remote Workflows](../git-mastery-05-remote-workflows/)

### Safety Reminder:
- ⚠️ **Never rewrite public history without coordination**
- ⚠️ **Always create backup branches**
- ⚠️ **Use reflog when things go wrong**
- ⚠️ **Communicate with your team**

**Happy (safe) history rewriting! 🚀**
