# Troubleshooting - History Rewriting Issues 🔧

Common problems when rewriting Git history and how to recover.

## 🚨 Critical Situations

### Issue 1: "I Did a Hard Reset and Lost Everything!"

**Panic Level:** 🔴 High

**Solution:**
```bash
# STAY CALM! Use reflog
git reflog

# Find commit before reset (look for "reset: moving to")
# Example: abc123 HEAD@{5}: commit: My important work

# Recover
git reset --hard HEAD@{5}
# Or: git reset --hard abc123

# Verify
git log --oneline
```

**Prevention:**
- Always create backup branch: `git branch backup`
- Check twice before `--hard`

---

### Issue 2: "Force Pushed and Broke Team's Work"

**Panic Level:** 🔴 Critical

**What Happened:**
```bash
git reset --hard HEAD~5
git push --force origin master  # ❌ Broke everyone's repos!
```

**Immediate Actions:**
```bash
# 1. Undo on your machine IMMEDIATELY
git reflog
git reset --hard HEAD@{1}  # Before force push
git push --force origin master  # Fix remote

# 2. Notify team in chat/email
"I accidentally force-pushed master. It's fixed now. Please pull."

# 3. Team members should:
git fetch origin
git reset --hard origin/master
```

**If Too Late:**
```bash
# Team members must rebase their work
git fetch origin
git rebase origin/master

# Or merge (preserves their work)
git fetch origin
git merge origin/master
```

**Prevention:**
- NEVER rewrite master/main
- Use `--force-with-lease` (safer)
- Enable branch protection on GitHub/GitLab

---

### Issue 3: "Amend After Push - Can't Push Now"

**Error:**
```
! [rejected]        master -> master (non-fast-forward)
error: failed to push some refs
```

**Cause:** Amended commit after pushing = different SHA.

**Solutions:**

**Option 1: Force push (if safe - personal branch)**
```bash
git push --force-with-lease origin feature-branch
```

**Option 2: Revert amend (if already pushed)**
```bash
git reflog
git reset --hard HEAD@{1}  # Before amend
git push origin master
```

**Option 3: Create new commit (safest)**
```bash
# Don't amend, just make new commit
echo "fix" >> file.txt
git add file.txt
git commit -m "Fix from previous commit"
git push origin master
```

---

### Issue 4: "Filter-Branch is Taking Forever"

**Symptom:** filter-branch running for hours.

**Causes:**
- Large repository
- Complex filter
- Many commits

**Solutions:**

**Option 1: Use git-filter-repo instead**
```bash
# Much faster than filter-branch
pip install git-filter-repo
git filter-repo --path secrets.txt --invert-paths
```

**Option 2: Filter specific branch**
```bash
# Don't use --all, specify branch
git filter-branch --index-filter "..." master
```

**Option 3: Shallow clone first**
```bash
git clone --depth 1000 original-repo filtered-repo
cd filtered-repo
git filter-branch ...
```

---

### Issue 5: "Can't Find Commit in Reflog"

**Symptom:** Reflog doesn't show expected commit.

**Possible Causes:**
- Reflog expired (older than 90 days)
- gc ran with aggressive prune
- Different branch reflog

**Solutions:**

```bash
# Check all reflog references
git reflog show --all

# Check specific branch
git reflog show feature-branch

# Search for commit
git fsck --lost-found
# Look in .git/lost-found/

# Search by commit message
git log --all --oneline | grep "commit message"

# Search by date
git log --all --since="2 weeks ago"

# Last resort: look for dangling commits
git fsck --unreachable
git fsck --no-reflog
```

---

### Issue 6: "Revert Created Conflicts"

**Error:**
```
error: could not revert abc123... Commit message
hint: after resolving the conflicts, mark the corrected paths
hint: with 'git add <paths>' or 'git rm <paths>'
hint: and commit the result with 'git commit'
```

**Cause:** Changes being reverted conflict with current code.

**Solutions:**

```bash
# View conflict
git status
git diff

# Resolve conflicts in files
code conflicted-file.txt

# Stage resolved files
git add conflicted-file.txt

# Complete revert
git revert --continue

# Or abort if too complex
git revert --abort
```

---

### Issue 7: "Reset Changed Files I Wanted to Keep"

**Symptom:** Used `--hard` but needed some changes.

**Solutions:**

```bash
# Check if changes still in reflog
git reflog
git show HEAD@{1}:path/to/file > recovered-file.txt

# Or cherry-pick specific changes
git reflog
git cherry-pick -n HEAD@{1}  # -n = don't commit
git restore --staged unwanted-file.txt
git commit -m "Recovered needed changes"

# Or use fsck to find blob
git fsck --lost-found
# Look in .git/lost-found/other/
```

---

## 🛠️ Common Mistakes

### Mistake 1: Amending Pushed Commits

```bash
# ❌ WRONG
git push origin master
git commit --amend -m "Fixed"
git push origin master  # FAILS

# ✅ RIGHT
git push origin master
git commit -m "Fix from previous commit"
git push origin master
```

---

### Mistake 2: Resetting Shared Branch

```bash
# ❌ WRONG
git checkout master
git reset --hard HEAD~5  # Others are using these!
git push --force origin master

# ✅ RIGHT
git checkout master
git revert HEAD~5..HEAD  # Safe for shared branches
git push origin master
```

---

### Mistake 3: Filter-Branch Without Backup

```bash
# ❌ WRONG
git filter-branch ...  # No backup!

# ✅ RIGHT
git branch backup-before-filter
git tag backup-tag-$(date +%Y%m%d)
git filter-branch ...
# Can recover: git reset --hard backup-before-filter
```

---

### Mistake 4: Force Push Without Lease

```bash
# ❌ DANGEROUS
git push --force origin feature

# ✅ SAFER
git push --force-with-lease origin feature
# Fails if remote changed (someone else pushed)
```

---

## 🔍 Diagnostic Commands

```bash
# Where am I?
git status
git branch --show-current

# What happened?
git reflog -10

# What changed?
git diff HEAD@{1}

# Is anything lost?
git fsck --lost-found

# What's in reflog?
git reflog --all --oneline

# Show all reachable commits
git log --all --oneline --graph

# Find dangling commits
git fsck --unreachable

# Check repository integrity
git fsck --full

# Show object size
git count-objects -vH
```

---

## 🎓 Prevention Best Practices

### 1. Always Create Backups

```bash
# Before dangerous operations
git branch backup-$(date +%Y%m%d-%H%M)
git tag backup-tag-$(date +%Y%m%d)

# Or create bundle
git bundle create ../repo-backup-$(date +%Y%m%d).bundle --all
```

### 2. Use Safer Alternatives

```bash
# Instead of reset --hard
git reset --soft HEAD~1      # Keep changes

# Instead of force push
git push --force-with-lease origin feature

# Instead of filter-branch
git filter-repo ...          # Faster, safer

# Instead of amending pushed commits
git commit -m "Fix"          # New commit
```

### 3. Test on Copy First

```bash
# Clone to test directory
git clone repo test-repo
cd test-repo

# Test dangerous operation
git filter-branch ...

# If works, do on real repo
cd ../repo
git filter-branch ...
```

### 4. Know Your Escape Routes

```bash
# Abort in-progress operations
git revert --abort
git reset --abort
git merge --abort
git rebase --abort

# Recover from reflog
git reflog
git reset --hard HEAD@{n}

# Recover from backup
git reset --hard backup-branch
```

---

## 📚 Advanced Recovery

### Recover Deleted Branch

```bash
# Find branch in reflog
git reflog show --all | grep branch-name

# Recreate from reflog
git branch recovered-branch HEAD@{10}

# Or from fsck
git fsck --lost-found
git branch recovered-branch <commit-sha>
```

### Recover After gc

```bash
# gc may have removed some commits
# But reflog helps
git reflog expire --expire=now --all
git reflog show --all

# Find last known commit
git log --all --oneline | grep "message"

# If truly lost, check backups
```

### Recover File from History

```bash
# Find when file was deleted
git log --all --full-history -- path/to/file

# Recover from specific commit
git checkout abc123 -- path/to/file

# Or show contents
git show abc123:path/to/file > recovered-file
```

---

## ⚠️ When to Ask for Help

Get help if:
- Lost important work and reflog doesn't help
- Filter-branch broke repository
- Team's repositories broken after your push
- gc ran and can't find commits
- Unsure what command to use

**Before asking:**
1. Run `git reflog > reflog.txt`
2. Run `git log --all --oneline --graph > log.txt`
3. Note what you did (commands)
4. Include error messages

---

## 🎯 Quick Fixes

```bash
# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes)
git reset --hard HEAD~1

# Undo amend
git reflog
git reset --hard HEAD@{1}

# Undo rebase
git rebase --abort
# Or: git reset --hard ORIG_HEAD

# Undo merge
git merge --abort
# Or: git reset --hard HEAD~1

# Undo force push (if just did it)
git reflog
git reset --hard HEAD@{1}
git push --force origin master
```

---

## 📖 Resources

- [Git Reflog Documentation](https://git-scm.com/docs/git-reflog)
- [Git Reset Documentation](https://git-scm.com/docs/git-reset)
- [Oh Shit, Git!?!](https://ohshitgit.com/)
- [Git Flight Rules](https://github.com/k88hudson/git-flight-rules)

**Remember: Git rarely loses data permanently. Check reflog first!** 🚀
