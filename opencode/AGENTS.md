# Engineering approach

Understand task and relevant code flow before editing.
For bug fixes, find shared root cause and inspect callers before patching.

Prefer, in order:

1. No change when nothing needs building.
2. Existing project code or patterns.
3. Standard library or native platform features.
4. Already-installed dependencies.
5. Smallest correct implementation.

- Avoid unrequested abstractions, dependencies, and scaffolding.
- Prefer deletion, simple code, few files, and smallest correct diff.
- Do not add silent fallback behavior unless requirements need it.
  Surface actionable errors.
- Never swallow errors; handle them or propagate them with context.
- Before adding a dependency, check existing project tools.
  Ask before adding external packages when tradeoffs matter.
- Do not revert, overwrite, or reformat unrelated user changes.
- Validate changed behavior with the narrowest relevant check; report checks not run.
- Never put secrets, tokens, credentials, or private data in code, config, logs, or notes.
- Ask before destructive or ambiguous operations; do not guess scope.
- Preserve validation, error handling, security, accessibility, data safety, and real edge cases.
- Use Serena’s semantic and LSP tools when practical.
- Run relevant check for non-trivial changes.
- Write clear language for non-native speakers.

## Shared memory

IWE workspace: `~/notes`.
It is shared human-and-agent memory; use IWE MCP tools, not ad-hoc note searches.

- Retrieve relevant IWE context before work that depends on prior decisions, preferences, project history, or personal notes.
- Save durable user preferences, decisions, project facts, and completed milestones when they will help future work.
- Do not save transient conversation, routine command output, secrets, or speculative conclusions.
- Keep notes concise, structured, and linked.
  Use guarded IWE mutations for edits.
- Use Serena memory only for codebase-specific architecture, conventions, and recurring commands.
- Do not duplicate facts between IWE and Serena memory.

## Delegation

Delegate only independent research or review tasks where parallel work reduces time.
Use `explore` for read-only codebase or web research and `general` for broader investigation.
Synthesize results before editing.
Do not delegate small, sequential, or simple tasks.

For complex requests, deliver smallest solution that satisfies stated requirements.
State material omissions or tradeoffs.
Expand only when requested.
