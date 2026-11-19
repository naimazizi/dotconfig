---
description: Review an OpenSpec change in Plannotator
argument-hint: "[change]"
---

Review the active OpenSpec change requested here: $ARGUMENTS

Find active changes in the current project's `openspec/changes/` directory.
Exclude `archive`.
If a change is named, match its directory exactly.
Report a missing or ambiguous change instead of guessing.
If no change is named and only one active change exists, select it.
If no change is named and there are multiple active changes, ask the user to select one.
If there are no active changes, ask the user for clarification.

Collect the selected change's existing `proposal.md`, `design.md`, `tasks.md`, and Markdown files recursively under `specs/`.
Do not assume every artifact exists.
If no reviewable artifacts exist, report this and stop.

Read `~/.agents/skills/plannotator-annotate/SKILL.md` and use its approval workflow.
Open all collected files in one session with `plannotator annotate --gate --json`, passing each file as a separate quoted argument.
Inspect both the exit status and JSON decision.
Report startup or command errors and stop.

For `annotated`, apply the feedback to the OpenSpec artifacts and offer another review.
For `approved`, treat any feedback as guidance.
For `dismissed`, stop without implementing the change.
Never treat dismissal as approval.
