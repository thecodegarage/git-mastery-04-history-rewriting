# Repository 4: History Rewriting ✏️

**Master Git's powerful history rewriting tools safely and effectively**

## 🎯 Learning Objectives

By completing this repository, you will:

- ✅ Use `git commit --amend` to fix recent mistakes
- ✅ Master `git reset` in all its forms (soft, mixed, hard)
- ✅ Understand `git revert` for safe history changes
- ✅ Use `git filter-branch` and `git filter-repo` for bulk changes
- ✅ Remove sensitive data from Git history
- ✅ Fix commit authorship and timestamps
- ✅ Know when history rewriting is safe vs dangerous
- ✅ Recover from history rewriting mistakes
- ✅ Clean up messy repository history

## 📊 Difficulty Level

🔴 **Advanced**

**Prerequisites:**
- Solid Git fundamentals (commit, branch, merge)
- Understanding of Git history and SHAs
- Experience with rebasing
- Comfort with command line

**Estimated Time:** 5-7 hours

## 🏗️ Repository Setup

This repository simulates an **E-commerce Platform** project with various history issues that need fixing.

### What You'll Practice

- **Amending Commits**: Fix messages, add missing files
- **Resetting**: Move HEAD to different commits
- **Reverting**: Safely undo changes
- **Filter Operations**: Bulk history changes
- **Cleanup**: Remove sensitive data, fix authorship

## 📚 What's Included

- **EXERCISES.md** - 15 hands-on history rewriting exercises
- **GIT-CHEATSHEET.md** - History rewriting commands + full Git reference
- **SOLUTIONS.md** - Detailed solutions with safety notes
- **TROUBLESHOOTING.md** - Common issues and recovery techniques

## 🚀 Getting Started

### 1. Create Practice Environment

**IMPORTANT**: Before starting exercises, run the setup script to create practice history:

```bash
# Make script executable (first time only)
chmod +x build-history.sh

# Run the setup script
./build-history.sh
```

This script creates:
- **~10 commits** with intentional mistakes
- **Multiple branches** with issues to fix
- **Realistic scenarios** requiring history rewriting

**Takes ~15 seconds to complete.**

**Need to start over?** Just run `./build-history.sh` again and type `y` to reset everything!

### 2. Verify Repository Setup

```bash
# View commit history
git log --oneline --graph --all

# Check branches
git branch -a

# Verify files were created
ls src/
```

### 3. Understand the Project

This is an e-commerce platform with:

```
src/
├── store.js         # Main store logic
├── products.js      # Product catalog
├── cart.js          # Shopping cart
├── checkout.js      # Checkout process
├── payment.js       # Payment processing
└── users.js         # User management
```

## 💡 Key Concepts

### History Rewriting Spectrum

```
Safest ────────────────────────────────────────► Most Dangerous
amend    revert    reset --soft    reset --mixed    reset --hard    filter-branch
```

### When History Rewriting is Safe ✅

- **Local commits** not yet pushed
- **Feature branches** you own
- **Before creating** pull requests
- **Private repositories** with coordination
- **Fixing mistakes** before others see them

### When to Avoid History Rewriting ❌

- **Commits pushed** to shared branches
- **Master/main branch** (usually)
- **Others based work** on your commits
- **Public repositories** without careful planning
- **Release branches** or tags

### The Three Types of Reset

```bash
# Soft: Move HEAD, keep staging and working directory
git reset --soft HEAD~1

# Mixed (default): Move HEAD, reset staging, keep working directory
git reset HEAD~1
git reset --mixed HEAD~1

# Hard: Move HEAD, reset staging and working directory (DESTRUCTIVE!)
git reset --hard HEAD~1
```

### Amend vs Revert vs Reset

| Command | Use Case | Safety |
|---------|----------|--------|
| `amend` | Fix last commit | Safe if not pushed |
| `revert` | Undo commit (preserve history) | Always safe |
| `reset` | Move branch pointer | Depends on type |

## ⚠️ Critical Safety Rules

### Rule 1: Never Rewrite Public History

```bash
# ❌ DANGER: Don't do this on shared branches!
git reset --hard HEAD~5
git push --force origin master

# ✅ SAFE: Use revert instead
git revert HEAD~5..HEAD
git push origin master
```

### Rule 2: Create Backups Before Dangerous Operations

```bash
# Always create backup branch
git branch backup-before-changes
git reset --hard abc123  # Now safe to experiment
```

### Rule 3: Know Your Recovery Options

```bash
# View reflog (your safety net)
git reflog

# Recover from mistakes
git reset --hard HEAD@{1}
```

## 🎓 Learning Path

### Recommended Order

1. **Exercise 1-3**: Amending commits
2. **Exercise 4-7**: Reset operations
3. **Exercise 8-10**: Reverting changes
4. **Exercise 11-13**: Filter operations
5. **Exercise 14-15**: Recovery and cleanup

### Estimated Time Per Section
- Amending: 1 hour
- Reset: 2 hours
- Revert: 1 hour
- Filter Operations: 2-3 hours
- Recovery: 1 hour

## 🔄 Reset & Practice Again

Want to start over?

```bash
# Delete and re-run script
rm -rf src/
git checkout master
git branch | grep -v "^\*" | grep -v "master" | xargs -r git branch -D
./build-history.sh

# Or re-clone
cd ..
rm -rf git-mastery-04-history-rewriting
git clone https://github.com/TheCodeGarage/git-mastery-04-history-rewriting
cd git-mastery-04-history-rewriting
chmod +x build-history.sh
./build-history.sh
```

## 📖 Additional Resources

- [Git Documentation - Reset](https://git-scm.com/docs/git-reset)
- [Git Documentation - Revert](https://git-scm.com/docs/git-revert)
- [Git Documentation - Filter-Branch](https://git-scm.com/docs/git-filter-branch)
- [Git Filter-Repo](https://github.com/newren/git-filter-repo) - Modern alternative
- [Pro Git - Rewriting History](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History)

## 🎯 Next Steps

After completing this repository:
- ✅ Practice with [Remote Workflows](../git-mastery-05-remote-workflows)
- ✅ Learn [Recovery Operations](../git-mastery-06-recovery-operations)
- ✅ Test your knowledge with the [Quiz Game](../git-mastery-quiz)

---

**Ready to master history rewriting?** Start with [EXERCISES.md](./EXERCISES.md)!

**⚠️ Remember**: With great power comes great responsibility. Always create backups!
