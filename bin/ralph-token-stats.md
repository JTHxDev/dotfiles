---
goal: Add persistent token/cost tracking to Ralph.sh
model: github-copilot/claude-opus-4.5
---

# Ralph Loop Iteration

## Goal
{{GOAL}}

## Context
Ralph.sh is a bash script at ~/dotfiles/bin/Ralph.sh that runs an agentic loop using opencode or claude CLI tools. It reads spec files with YAML frontmatter and executes prompts in a loop.

## Requirements

### 1. Add jq dependency check
- Check for `jq` at startup
- Exit with helpful error message if missing: "Error: jq is required. Install with: brew install jq"

### 2. Switch to JSON output mode
- opencode: use `opencode run --format json "$PROMPT"` instead of `opencode -p`
- claude: use `--output-format json` flag in addition to existing flags

### 3. Capture and parse JSON output
- Capture output to a temp file
- Extract the response text and display it to the user
- Parse token stats separately

### 4. Parse token stats using jq
For opencode, look for fields in message info:
- `tokens.input`, `tokens.output`, `tokens.cache.read`, `tokens.cache.write`, `cost`

For claude, look for:
- `usage.input_tokens`, `usage.output_tokens`, `usage.cache_read_input_tokens`, `usage.cache_creation_input_tokens`, `total_cost_usd`

### 5. Track cumulative session totals
- Initialize counters: TOTAL_INPUT=0, TOTAL_OUTPUT=0, TOTAL_CACHE_READ=0, TOTAL_COST=0
- Add each loop's stats to the running totals

### 6. Display stats box at bottom
Show formatted stats box before "Press Enter" prompt:
```
┌────────────────────────────────────────────────────────────────────┐
│ This Loop │ In: 45.2K │ Out: 2.1K │ Cache: 120K │ Cost: $0.12     │
│ Session   │ In: 156K  │ Out: 8.4K │ Cache: 380K │ Cost: $0.45     │
└────────────────────────────────────────────────────────────────────┘
```

### 7. Format numbers human-readable
- Create a function to format large numbers with K/M suffixes
- Example: 45200 -> "45.2K", 1500000 -> "1.5M"

## Files to modify
- ~/dotfiles/bin/Ralph.sh

## Instructions
You are running in a Ralph loop. Follow these steps exactly:

1. **Read State**: Read Ralph.sh and understand current implementation
2. **Assess Progress**: What requirements are done? What's remaining?
3. **Pick ONE Task**: Choose the single most important next requirement
4. **Execute**: Complete that task fully
5. **Verify**: Confirm the code is syntactically correct
6. **Report**: Summarize what you did and what the next task should be

## Rules
- Do ONE requirement only, then stop
- Be thorough on that one task
- If blocked, explain why and suggest resolution
- Keep existing functionality working

## Output Format
End your response with:
---
COMPLETED: [what you did]
NEXT: [suggested next task]
STATUS: [percentage complete estimate]
