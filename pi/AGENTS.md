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

Delegate only independent research or review tasks when parallel work saves time.
Check which agents are available before choosing one; do not assume agent names exist.
Use a read-only agent for research or review when available.
Give each agent a bounded task and the context it needs.
Synthesize results before editing.
Do not delegate small, sequential, or simple tasks.

State material omissions or tradeoffs.

## Unslop

Source: [Unslop](https://github.com/cursor/plugins/blob/main/pstack/skills/unslop/SKILL.md).

Edit text to remove AI patterns.
Scan for the patterns below, then rewrite.
Preserve meaning and match the intended tone.

- No trailing "-ing" phrases that add no fact ("highlighting...", "ensuring...").
- No vague attributions ("experts believe").
  Name the source or delete.
- No AI vocabulary: additionally, crucial, delve, enhance, foster, landscape, pivotal, showcase, testament, underscore, vibrant.
- Say "is" or "has", not "serves as", "stands as", "boasts", "features".
- No "not just X, but Y".
  State the point.
- Don't force ideas into threes.
- One name per thing.
  Repeat it.
- No "from X to Y" unless X and Y sit on a real scale.
- No em dashes, en dashes, or hyphens used as dashes, and no parentheses in their place.
  Use a period or a comma.
- A colon goes before a list or an example, never mid-sentence as a connector.
- Don't bold every proper noun or acronym.
- No bold label and colon that restates its line ("**Performance:** Performance improved...").
  A bold lead-in that ends in a period and adds new detail is fine.
- Sentence case headings.
- No decorative emojis.
- Straight quotes.
- No chatbot phrases ("I hope this helps!", "Let me know if...").
- No praise or agreement openers.
  Respond directly.
- Cut filler.
  "In order to" becomes "to".
  Delete "it is important to note that".
- One hedge at most: "may".
- No generic conclusions.
  State specific plans or facts.
- No abstract metaphor nouns: substrate, wedge, vector, nexus, primitive, harness, surface, scaffolding, paradigm, ratchet, north star, flywheel.
  Use the concrete word.
- Say what it does, not how it feels.
  Name the mechanism or the number.
  Cut a sentence that could appear unchanged in another project's docs.
- One idea per sentence.
  Split a sentence the reader has to reread.
- Active voice.
  Name the actor unless it is unknown or doesn't matter.
- Cut adverbs or use a stronger verb.
  Give the number.
- Use the plain word: "use", not "utilize" or "leverage".
- No metaphor, aphorism, personified code, or figurative verb where a literal phrase exists.
- Write whole sentences with their articles and verbs.
  Spell out arrows and abbreviations.
