# Engineering approach

- Do not add silent fallback behavior unless requirements need it.
  Surface actionable errors.
- Never swallow errors; handle them or propagate them with context.
- Ask before adding external packages when tradeoffs matter.
- Do not revert, overwrite, or reformat unrelated user changes.
- Validate changed behavior with the narrowest relevant check; report checks not run.
- Never put secrets, tokens, credentials, or private data in code, config, logs, or notes.
- Ask before destructive or ambiguous operations; do not guess scope.
- Use Serena’s semantic and LSP tools when practical.
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

State material omissions or tradeoffs.
