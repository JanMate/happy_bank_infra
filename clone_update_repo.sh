#!/bin/bash

# Added color variables
txtrst=$(tput sgr0) 
txtred=$(tput setaf 1)

# Add announcement that this script has just started with timestamp
echo "${txtred}Timestamp:${txtrst} Script has started at $(date +%T)"

#Verify if remote repository exists
remote_repo_path=https://github.com/JanMate/happy_bank_core.git
remote_repo_ls=$(git ls-remote $remote_repo_path)
if [[ -z "$remote_repo_ls" ]]; then
  echo "Remote repository doesn't exist or empty, script has ended at $(date +%T)"
  exit
fi

# Clone the "happy_bank_core" repo from Github
echo "${txtred}Cloning remote repository..${txtrst}"
git clone $remote_repo_path
cd happy_bank_core

# Create a new branch "update-readme" and checkout it
echo "${txtred}Created new branch:${txtrst}"
new_branch_name=update-readme
git checkout -b $new_branch_name

# Update README in cloned repo - copy there the differences of the file in this repo
# Commit message and Workflow sub-sections (Hint: Try to use "head" or "tail" command + pipe "|" to redirect output)
echo "${txtred}Updated content of the README.md:${txtrst}"
cat ../README.md | tail -n 76 >> README.md

# Add your change to git stage area
echo "${txtred}Added changes to stage area:${txtrst}"
git add README.md

# Show user git status
echo "${txtred}Git Status:${txtrst}"
git status

# Commit the new change with message: "minor: Distribute GitOps instructions to README.md"
echo "${txtred}Committed last change${txtrst}"
git commit -m 'minor: Distribute GitOps instructions to README.md'

# Verify you are up-to-date
echo "${txtred}Verified if repo is up-to-date:${txtrst}"
git pull --rebase origin main

# Push changes to origin
echo "${txtred}Pushed changes to origin${txtrst}"
git push -u origin $new_branch_name

# Show git log with 5 latest commits
echo "${txtred}5 latest commits:${txtrst}"
git --no-pager log --oneline --graph -n 5

# Print git blame of the updated file
echo "${txtred}Git Blame of the updated file:${txtrst}"
git --no-pager blame README.md

# Create a new tag "0.0.1" of the latest change
echo "${txtred}Created and showed new tag for the latest commit${txtrst}"
git tag -a v0.0.1 -m "my version 0.0.1"
git --no-pager show v0.0.1

# Revert the last change to cancel it
echo "${txtred}Reverted the last commit${txtrst}"
git revert --no-edit HEAD
git --no-pager log --oneline --graph -n 2
git status

# Reset the graph on the branch to the beginning, but keep all changes in stage area
# Compare the difference between git revert and reset in your mind
echo "${txtred}Resetted the branch:${txtrst}"
git reset --soft HEAD~1
git status

# add new section
echo "${txtred}Added new section${txtrst}"
echo "this is a new section #1" >> README.md

# Add your change to git stage area
echo "${txtred}Added last change to git stage area${txtrst}"
git add README.md

# Commit the new change with message: "minor: Distribute GitOps instructions to README.md"
echo "${txtred}Committed new section${txtrst}"
git commit -m "minor: Distribute GitOps instructions to README.md"

# add another section
echo "${txtred}Added new section #2${txtrst}"
echo "this is a new section #2" >> README.md

# Add your change to git stage area
echo "${txtred}Added last change to git stage area${txtrst}"
git add README.md

# Commit the new change to previous commit (new change must be part of the existing commit)
echo "${txtred}Committed last change to previous commit${txtrst}"
git commit --amend --no-edit
git --no-pager log --oneline --graph -n 2

# Show difference between new and previous commit on the updated file
echo "${txtred}Showed diff between last 2 commits${txtrst}"
git --no-pager diff HEAD~1 HEAD

# Push changes to origin
echo "${txtred}Pushed to origin${txtrst}"
git push -u origin $new_branch_name 

# Switch to main branch
echo "${txtred}Switched to main branch${txtrst}"
git checkout main

# Remove "update-readme" branch on origin and keep only the local one
echo "${txtred}Removed remote branch${txtrst}"
git push origin --delete $new_branch_name

# Remove repo
working_dir=$(pwd)
rm -rf "$working_dir"

# Add announcement that this script has just finished with timestamp
echo "Script has finished at $(date +%T)"