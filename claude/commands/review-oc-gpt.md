You will receive zero or one argument as a single string: "$ARGUMENTS"

Parse it as follows:
- If `$ARGUMENTS` is empty / whitespace, derive the PR from the current working directory: it must be a git repo whose current branch has exactly one open PR (use `gh pr view --json number,url,headRefName,baseRefName,title,headRepositoryOwner,headRepository`). If there is no PR, or more than one, abort with an explanatory message.
- Otherwise, treat `$ARGUMENTS` as a single integer = PR_NUMBER. Validate it is a positive integer; abort if not. Then resolve the PR via `gh pr view $PR_NUMBER --json number,url,headRefName,baseRefName,title,headRepositoryOwner,headRepository`.

Preconditions, run in order:

1. Confirm `gh` and `opencode` are installed (`command -v gh`, `command -v opencode`); abort with install hint if either is missing.
2. Confirm the cwd is a git repo (`git rev-parse --is-inside-work-tree`).
3. Resolve the PR per the rules above. Capture: `PR_NUMBER`, `PR_URL`, `PR_HEAD_BRANCH`, `PR_BASE_BRANCH`, `PR_TITLE`, `OWNER/REPO` (slug, e.g. `acme/widgets`).
4. Make sure the working tree contains the latest code of the PR head branch:
   - `git fetch origin "$PR_HEAD_BRANCH"`
   - The current branch must equal `$PR_HEAD_BRANCH` AND must be up-to-date with `origin/$PR_HEAD_BRANCH` (no unpushed commits ahead, no commits behind). If either check fails, abort and tell the user to check out / pull the PR branch first — do NOT auto-checkout or auto-pull, since uncommitted work may exist.
   - The working tree must be clean (`git status --porcelain` empty); abort otherwise.
5. Build the opencode prompt below using the resolved PR metadata, then run:

   ```sh
   opencode run \
     -m github-copilot/gpt-5.3-codex \
     --dangerously-skip-permissions \
     "$PROMPT"
   ```

   Stream opencode's output to the user as it runs. Do not wrap or post-process it. After it exits, print the PR URL so the user can open it.

---

## Prompt to send to opencode

Substitute the bracketed placeholders with the values resolved above. Pass the result as a single string argument to `opencode run`.

```
You are doing an iterative code review of GitHub PR [OWNER/REPO]#[PR_NUMBER] — "[PR_TITLE]" ([PR_URL]).

Context:
- The PR head branch "[PR_HEAD_BRANCH]" is checked out in the current working directory at its latest commit. Treat the local files as the source of truth for the code under review.
- The base branch is "[PR_BASE_BRANCH]". Use `git diff [PR_BASE_BRANCH]...HEAD` (or `gh pr diff [PR_NUMBER]`) to see what this PR changes.
- This PR may already have prior review iterations from you. Your previous comments are tagged with the marker string "review-oc-gpt" somewhere in the comment body. Treat any review comment NOT carrying that marker as authored by a human — do not resolve or modify it.

Do exactly this, in order:

1. Fetch all currently-open review threads on the PR:
     gh api graphql -f query='query($o:String!,$r:String!,$n:Int!){repository(owner:$o,name:$r){pullRequest(number:$n){reviewThreads(first:100){nodes{id isResolved comments(first:20){nodes{id body path line}}}}}}}' \
       -F o=[OWNER] -F r=[REPO] -F n=[PR_NUMBER]
   For each unresolved thread whose first comment body contains "review-oc-gpt":
     a. Re-read the relevant file(s) at the current HEAD to determine if the issue you raised is now fixed.
     b. If fixed, post a brief reply on the existing review thread (also a line-anchored review comment by virtue of replying — use `gh api repos/[OWNER]/[REPO]/pulls/[PR_NUMBER]/comments/<root_comment_id>/replies --method POST --field body="..."`), tagged "review-oc-gpt", noting it is resolved and at which commit (`git rev-parse HEAD`). Then resolve the thread via the `resolveReviewThread` GraphQL mutation.
     c. If NOT fixed, leave it alone — do not duplicate or re-comment.

2. Re-review the latest version of the PR end-to-end. Focus on critical issues only:
     - correctness bugs / logic errors
     - security vulnerabilities
     - data loss / corruption risks
     - concurrency / race conditions
     - severe performance regressions
     - public API / contract breakage
   Do NOT comment on style, naming, formatting, minor refactors, or speculative concerns. If there is nothing critical, do NOT post any new PR comment — proceed to step 4 and report "all clear" only in the final stdout summary.

3. For each critical issue found that is NOT already covered by an existing open "review-oc-gpt" thread, leave a **line-anchored Pull Request Review Comment** (the kind that has a "Resolve conversation" button — backed by GitHub's pull request review comments API). Do NOT use `gh pr comment` — that posts a general PR conversation comment with no resolve button, which is the wrong type for this workflow. There is no first-class `gh` subcommand for line comments, so call the REST API directly:

   ```sh
   # a. Get the head commit SHA of the PR (line comments must anchor to a commit)
   HEAD_SHA=$(gh api repos/[OWNER]/[REPO]/pulls/[PR_NUMBER] --jq '.head.sha')

   # b. Create one review with one or more line-anchored comments batched together
   gh api repos/[OWNER]/[REPO]/pulls/[PR_NUMBER]/reviews \
     --method POST \
     --field event="COMMENT" \
     --field body="" \
     --field "comments[][path]=<file path>" \
     --field "comments[][line]=<line number on the RIGHT side of the diff>" \
     --field "comments[][side]=RIGHT" \
     --field "comments[][body]=<comment body, starting with review-oc-gpt marker>" \
     --field "comments[][commit_id]=$HEAD_SHA"
   ```

   Repeat the `comments[][...]` block for each finding to batch them in a single review call. The `path` and `line` MUST refer to a line that is part of the PR diff on the RIGHT (new) side; verify with `gh pr diff [PR_NUMBER]` before posting, otherwise the API rejects the comment.

   Every comment body MUST:
     - start with the literal marker "review-oc-gpt" on its own line, so future iterations can identify it
     - state the file:line, the problem, why it matters, and a concrete suggested fix
     - be specific and actionable; no vague "consider …" framing

4. At the end, print a short plain-text summary to stdout listing:
     - threads you resolved (with thread IDs)
     - new critical comments you posted (with file:line)
     - if no new critical issues were found this iteration, print the line "all clear: no new critical issues" (this goes to stdout only — do not post it as a PR comment)

Constraints:
- Do not push commits, edit files, or modify the branch. Review only.
- Do not invent file paths or line numbers — verify them against the current working tree.
- If a tool call fails, report the failure in the final summary instead of silently continuing.
```

---

## Usage

```
/review-oc-gpt           # use PR of current branch
/review-oc-gpt 1234      # explicit PR number
```
