---
name: address-pr-comments
description: Analyze and address unresolved PR review comments. Use when working through PR feedback, replying to review threads, or resolving code review items.
---

# PR Review Comments Workflow

Address unresolved review comment threads on a GitHub pull request.

## Detect the PR

Infer the PR from the current branch:
```bash
gh pr view --json number,url --jq '.number'
```

## Phase 1: Fetch and categorize unresolved threads

1. Fetch review threads with resolved status using the GraphQL API. This is the only reliable way to get `isResolved` — the REST API does not expose it.

   The `reviewThreads` connection caps at 100 per page and does not support filtering by `isResolved`, so you must paginate and filter client-side. Use `pageInfo.hasNextPage` and `pageInfo.endCursor` to fetch all pages:

   **Important**: Do not pass the query inline with `-f query='...'` — the Bash tool escapes `!` to `\!` even inside single quotes, which produces invalid GraphQL. Write the query to a temp file and use `-F query=@file` instead.

   Write this to e.g. `.context/pr-threads-query.graphql`:
   ```graphql
   query($owner: String!, $repo: String!, $pr: Int!, $cursor: String) {
       repository(owner: $owner, name: $repo) {
         pullRequest(number: $pr) {
           reviewThreads(first: 100, after: $cursor) {
             pageInfo { hasNextPage endCursor }
             nodes {
               id
               isResolved
               isOutdated
               comments(first: 50) {
                 nodes {
                   id
                   databaseId
                   author { login }
                   body
                   path
                   line
                   originalLine
                   createdAt
                 }
               }
             }
           }
         }
       }
   }
   ```

   Then run:
   ```bash
   gh api graphql --paginate -F query=@.context/pr-threads-query.graphql \
     -f owner=OWNER -f repo=REPO -F pr=NUMBER
   ```

   Note: `gh api graphql --paginate` auto-paginates when the query uses a `$cursor` variable and the response includes `pageInfo`.

2. Filter to threads where `isResolved == false`.

3. For each unresolved thread, categorize:
   - **Human reviewer** (real GitHub users) vs **Bot reviewer** (e.g. `coderabbitai[bot]`)
   - **Actionable** (requires a code change, comment fix, or investigation)
   - **Informational/deferred** (already deferred to an issue, or just a discussion point)

4. Present a summary table to the user showing each unresolved thread:
   - Root comment database ID
   - File and line
   - Reviewer
   - Summary of what's being asked
   - Your recommended action (fix, investigate, reply-only, defer)

**⛔ STOP: Wait for the user to confirm which threads to address before proceeding. Do NOT start investigating or making changes yet.**

## Phase 2: Address threads

For each thread the user wants addressed:

1. **Investigate**: Read the relevant code, understand the concern, and determine if a code change is needed.

2. **If a code change is needed**: Make the change. Keep changes minimal and focused on what the reviewer asked for.

3. **If no change is needed**: Prepare an explanation of why (e.g. types guarantee safety, existing guard handles it, etc.). Verify your reasoning by reading the actual code.

4. **If deferring**: Note that it should be captured in a follow-up issue if not already.

**⛔ STOP: Present your proposed actions and reply drafts to the user for review. Do NOT commit, push, or post replies yet.**

## Phase 3: Commit, push, and reply

After explicit user approval of the proposed actions and reply drafts:

1. **Commit** all code changes in a single commit with a message like:
   ```
   Address PR review comments from #<number>
   ```

2. **Push** to the remote branch.

3. **Post replies** to each addressed thread using the established format. Use the root comment's `databaseId` as `in_reply_to`:

   For threads where code was changed:
   ```
   gh api repos/{owner}/{repo}/pulls/{number}/comments \
     -f "body=Resolved in <short-sha> — <brief description>.

   *— Claude*" \
     -F in_reply_to=<root_comment_database_id>
   ```

   For threads where no change was needed:
   ```
   gh api repos/{owner}/{repo}/pulls/{number}/comments \
     -f "body=Not an issue — <explanation>.

   *— Claude*" \
     -F in_reply_to=<root_comment_database_id>
   ```

   For threads being deferred:
   ```
   gh api repos/{owner}/{repo}/pulls/{number}/comments \
     -f "body=Captured in <issue-url> — will address in a follow-up.

   *— Claude*" \
     -F in_reply_to=<root_comment_database_id>
   ```

## Guidelines

- Always verify claims by reading actual code before replying. Don't trust bot analysis at face value.
- Keep reply text concise — one or two sentences describing what changed or why no change is needed.
- When investigating bot comments, check if the type system or runtime guarantees already prevent the issue.
- Group related changes into a single commit rather than one commit per thread.
- Never post replies without user approval first.
