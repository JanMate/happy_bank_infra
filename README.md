# happy_bank_infra
This repo contains the simple example of bank infrastructure.

## Commit message format:
```
severity: Header sentence

Body paragraph.

Mentioning issue ID
```
**severity**: 
 - BREAKING CHANGE - ensure updates major base: *1*.2.3
 - feat - ensure updates minor base: 1.*2*.3
 - fix, chore, test, perf, ci, style, doc - ensure updates patch base: 1.2.*3*
 
**mentioning** must contains keywords:
 - closes, 
 - fixes, 
 - resolves

### Example:
```
BREAKING CHANGES: Remove path parameter of core deployment

It removes path parameter replaced by url in core deployment.

Closes #1
```
or
```
feat: Add new connector

It adds new connector to connect DB.

Closes #1
```
or
```
fix: Fix connector parameters

It fixes parameters of connector to connect DB.

Closes #1
```

**NOTE:** If you commit a change that should not be merged so far, add "WIP" to the first line to prevent merging unfinished work.

Example:
```
WIP minor: Add new connector

It adds new connector to connect DB.

Closes #1
```

## Workflow

1. Choose a new task (issue) on the [project board](https://github.com/users/JanMate/projects/2) and move it into "**In progress**" column.


2. Open the repo related to your chosen task in your IDE and pull and rebase onto **origin main** branch.
   ```shell
   git pull --rebase origin main
   ```

3. For **every task** create a **new branch** that's based on **main** branch.
    - Example:
        - Task says: `Implement logic layer of core application...`
        - Branch name should be similar to: `implement-logic-layer` (concat the words with dash "-")
   ```shell
   git checkout -b <branch-name>
   ```

4. Commit your change. (Please, split your changes on logical parts if it's possible and makes sense.)
   ```shell
   git commit -am 
   ```
   If you forget something, you can use:
   ```shell
   git commit --amend
   ```


7. Since you are done with the task or want to back up your changes, push your commits to the **origin**.
   ```shell
   git push origin <branch-name>
   ```

8. After push step, create a new Pull Request (PR) in the repo Web UI to request merging of your branch into **main** branch.
   1. Open GitHub repo in your browser
   2. Either, on homepage or in "Pull requests" page hit the "New pull request" button
   3. Choose [JanMate](https://github.com/JanMate) as a reviewer
   4. Choose yourself as an assignee
   5. If you are not done and want to proceed with the task (due to back up), **select** the PR as "Draft"


9. If you need to update your PR, you must force push your commits.
   ```shell
   git push --force origin <branch-name>
   ```
