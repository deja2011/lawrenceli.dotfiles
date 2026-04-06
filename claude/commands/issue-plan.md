You will receive two arguments as a single string: "$ARGUMENTS"

Parse them as follows:
- First token = REPO (the subdirectory name of the target git repo)
- Second token = `ISSUE_ID` (an integer GitHub issue number)

Then execute these steps in order:

1. **Verify REPO is accessible** — confirm that REPO exists as a directory reachable from the current working directory. Abort with an error if not found.
2. **Verify the issue exists and is open** — run `gh issue view $ISSUE_ID --repo $(cd REPO && gh repo view --json nameWithOwner -q .nameWithOwner)` from within REPO. Abort if the issue does not exist or its state is not `OPEN`.
3. **Verify the `tasks/` directory exists** inside REPO. Abort if it is missing.

If any verification fails, print a clear error message and stop — do not proceed.

---

If all checks pass:

4. **Derive the branch name** — read the issue title from the `gh issue view` output. Slugify it to at most 5 `kebab-case` words. Compose the branch name as `{ISSUE_ID}-{short-description}` (e.g. `42-add-order-retry-logic`).

5. **Checkout the branch** — from within REPO:
   - If the branch already exists locally or remotely, check it out (`git checkout` / `git checkout --track`).
   - Otherwise create it fresh off the current default branch (`git checkout -b`).

6. **Build the plan** — read the full issue body and any existing comments from `gh issue view $ISSUE_ID --comments`. Analyse the scope of work and produce a structured implementation plan covering:
   - **Goal** — one-sentence summary of what the issue asks for.
   - **Background / context** — relevant details drawn from the issue description.
   - **Approach** — the strategy you recommend (design decisions, alternatives considered).
   - **Task breakdown** — numbered checklist of concrete implementation steps, ordered by dependency. Each step should be actionable enough to map to a single commit or small PR.
   - **Open questions** — anything ambiguous in the issue that needs clarification before or during implementation.
   - **Out of scope** — explicit list of things the issue does *not* ask for, to prevent scope creep.

7. **Write or refine the plan file** at `REPO/tasks/{branch-name}.md`:
   - If the file **does not exist**, create it with the plan generated in step 6.
   - If the file **already exists**, read it, compare it against the current issue content, and produce a refined version — preserving any manual edits or completed checklist items while updating stale sections and appending new tasks where appropriate. Clearly note any changes made in a `## Revision notes` section at the top.

---

## Usage
```
/issue-plan aiolos-lib 42
/issue-plan vortex 7
```
