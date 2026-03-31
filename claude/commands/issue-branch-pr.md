You will receive two arguments as a single string: "$ARGUMENTS"

Parse them as follows:
- First token = REPO (the subdirectory name of the target git repo)
- Remaining tokens = LABEL (the GitHub issue label, e.g. enhancement, bug)

Then execute these steps in order, scoped entirely to the REPO directory:

1. `cd` into REPO from the current working directory, or stay in the current directory if it is already REPO
2. Confirm it is a valid git repo (`git remote -v`), abort if not
3. Confirm the LABEL is within the list: bug, documentation, enhancement, new-feature, refactor. Abort if not.
4. Create a GitHub issue using `gh issue create` with:
   - Title summarising the changes made in REPO
   - Label set to LABEL
   - Body describing what was changed and why
   - Capture the returned issue number as `ISSUE_ID`
5. Checkout a new branch named `{ISSUE_ID}-{short-description}` where `short-description` is a `dash-case` slug of the issue title (max 5 words)
6. Stage and commit all changes inside REPO with a conventional commit message referencing the issue
7. Push the branch
8. Open a pull request with `gh pr create` targeting the default branch, referencing the issue in the PR body

All git and gh commands must be run from within the REPO directory.

---

## Usage
```
/issue-branch-pr aiolos-lib enhancement
/issue-branch-pr vortex bug
/issue-branch-pr aiolos-lib refactor
```
