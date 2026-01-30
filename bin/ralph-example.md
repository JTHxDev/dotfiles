---
goal: Build the project according to this spec
repo: ~/Repos/my-project
model: anthropic/claude-sonnet-4-5
---

# Ralph Loop Iteration

## Goal
{{GOAL}}

## Instructions
You are running in a Ralph loop. Follow these steps exactly:

1. **Read State**: Read this spec file and check what files exist
2. **Assess Progress**: What's done? What's remaining?
3. **Pick ONE Task**: Choose the single most important next task
4. **Execute**: Complete that task fully
5. **Verify**: Confirm the task works (check syntax, test if applicable)
6. **Report**: Summarize what you did and what the next task should be

## Rules
- Do ONE task only, then stop
- Be thorough on that one task
- Update progress checkboxes below as you complete items
- If blocked, explain why and suggest resolution

## Tasks
- [ ] Task 1: Description here
- [ ] Task 2: Description here
- [ ] Task 3: Description here

## Output Format
End your response with:
---
COMPLETED: [what you did]
NEXT: [suggested next task]
STATUS: [percentage complete estimate]
