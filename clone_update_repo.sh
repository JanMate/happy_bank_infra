#!/bin/bash

# Added color variables
RED='\033[0;31m'
NC='\033[0m'

# Add announcement that this script has just started with timestamp
echo -e "${RED}Timestamp:${NC} Script has started at $(date +%T)"

#Verify if remote repository exists
remote_repo_url=https://github.com/JanMate/happy_bank_core.git
remote_repo_ls=$(git ls-remote $remote_repo_url)
if [[ -z "$remote_repo_ls" ]]; then
  echo "Remote repository doesn't exist or empty, script has ended at $(date +%T)"
  exit
fi

# Clone the "happy_bank_core" repo from Github
echo -e "${RED}Cloning remote repository..${NC}"
git clone $remote_repo_url
cd happy_bank_core || exit

# Create a new branch "update-readme" and checkout it
echo -e "${RED}Created new branch:${NC}"
new_branch_name=update-readme
git checkout -b "$new_branch_name"

# Update README in cloned repo - copy there the differences of the file in this repo
# Commit message and Workflow sub-sections (Hint: Try to use "head" or "tail" command + pipe "|" to redirect output)
echo -e "${RED}Updated content of the README.md:${NC}"
< ../README.md head -n 79 | tail -n +4 >> README.md

# Add your change to git stage area
echo -e "${RED}Added changes to stage area:${NC}"
git add README.md

# Show user git status
echo -e "${RED}Git Status:${NC}"
git status

# Commit the new change with message: "minor: Distribute GitOps instructions to README.md"
echo -e "${RED}Committed last change${NC}"
git commit -m 'minor: Distribute GitOps instructions to README.md'

# Verify you are up-to-date
echo -e "${RED}Verified if repo is up-to-date:${NC}"
git pull --rebase origin main

# Push changes to origin
echo -e "${RED}Pushed changes to origin${NC}"
git push -u origin "$new_branch_name"

# Show git log with 5 latest commits
echo -e "${RED}5 latest commits:${NC}"
git --no-pager log --oneline --graph -n 5

# Print git blame of the updated file
echo -e "${RED}Git Blame of the updated file:${NC}"
git --no-pager blame README.md

# Create a new tag "0.0.1" of the latest change
echo -e "${RED}Created and showed new tag for the latest commit${NC}"
git tag -a v0.0.1 -m "my version 0.0.1"
git --no-pager show v0.0.1

# Revert the last change to cancel it
echo -e "${RED}Reverted the last commit${NC}"
git revert --no-edit HEAD
git --no-pager log --oneline --graph -n 2
git status

# Reset the graph on the branch to the beginning, but keep all changes in stage area
# Compare the difference between git revert and reset in your mind
echo -e "${RED}Resetted the branch:${NC}"
git reset --soft HEAD~1
git status

# add new section
echo -e "${RED}Added new section${NC}"
echo "this is a new section #1" >> README.md

# Add your change to git stage area
echo -e "${RED}Added last change to git stage area${NC}"
git add README.md

# Commit the new change with message: "minor: Distribute GitOps instructions to README.md"
echo -e "${RED}Committed new section${NC}"
git commit -m "minor: Distribute GitOps instructions to README.md"

# add another section
echo -e "${RED}Added new section #2${NC}"
echo "this is a new section #2" >> README.md

# Add your change to git stage area
echo -e "${RED}Added last change to git stage area${NC}"
git add README.md

# Commit the new change to previous commit (new change must be part of the existing commit)
echo -e "${RED}Committed last change to previous commit${NC}"
git commit --amend --no-edit
git --no-pager log --oneline --graph -n 2

# Show difference between new and previous commit on the updated file
echo -e "${RED}Showed diff between last 2 commits${NC}"
git --no-pager diff HEAD~1 HEAD

# Push changes to origin
echo -e "${RED}Pushed to origin${NC}"
git push -u origin "$new_branch_name" 

# Switch to main branch
echo -e "${RED}Switched to main branch${NC}"
git checkout main

# Remove "update-readme" branch on origin and keep only the local one
echo -e "${RED}Removed remote branch${NC}"
git push origin --delete "$new_branch_name"

# Remove repo
working_dir=$(pwd)
rm -rf "$working_dir"

# Add announcement that this script has just finished with timestamp
echo "Script has finished at $(date +%T)"