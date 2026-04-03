---
name: prompt-to-docs-plan
description: Generate a docs plan file from a user prompt, including plan name, detailed description, impact analysis of .cursor/ rules/skills, and risk hotspots. Use when the user asks for a plan, documentation, or impact analysis from a prompt.
---

# Prompt-to-Docs Plan

When the user provides a prompt and wants a plan documented:

1. **Create a file in `docs/`** with an AI-generated filename based on the prompt
2. **Follow the output template** below
3. **Read all files in `.cursor/`** (rules, skills, plans) to perform impact analysis
4. **Write the complete document** to the new file

---

## Step 1: Generate Filename

Derive a concise, snake_case filename from the prompt:

| Prompt example           | Filename example                    |
|--------------------------|-------------------------------------|
| "Add user authentication"| `add_user_authentication_plan.md`   |
| "Refactor API layer"     | `refactor_api_layer_plan.md`       |
| "New settings screen"    | `new_settings_screen_plan.md`      |

Use descriptive nouns and verbs. Prefer `*_plan.md` unless the prompt clearly indicates another type (e.g. `*_review.md`).

---

## Step 2: Read .cursor/ Context

Before writing, read these paths (use `Read` or `Glob`):

- `.cursor/rules.mdc` — authoritative rule index
- `.cursor/rules.md` — short human index (optional)
- `.cursor/rules/*.mdc` — individual rules
- `.cursor/skills/**/SKILL.md` — skills and their descriptions
- `AGENTS.md` — agent instructions (if non-empty)

---

## Step 3: Output Template

Write the document using this structure. Replace placeholders with real content.

```markdown
# [Plan Name]

> **Source prompt:** [User's original prompt in quotes]  
> **File:** `docs/[generated_filename].md`

---

## 1. Plan Summary

[2–4 sentences describing what the plan achieves and its scope.]

---

## 2. Detailed Description

[Detailed breakdown of the plan: steps, components, flow, decisions. Use headings and bullets as needed.]

### 2.1 Scope
- What is in scope
- What is out of scope

### 2.2 Approach
- Main approach and alternatives considered
- Key decisions and rationale

### 2.3 Implementation Outline
- Step-by-step implementation notes
- Files/areas to touch (high level)

---

## 3. Impact on .cursor/ Configuration

[How the plan affects rules, skills, and project conventions in `.cursor/`.]

### 3.1 Rules Affected

| Rule / File | Scope | Impact | How It Works |
|-------------|-------|--------|--------------|
| `[rule_name]` | [globs/scope] | [Description of change] | [How the rule interacts with this plan] |

(Repeat for each affected rule.)

### 3.2 Skills Affected

| Skill | Description | Impact | When to Use |
|-------|-------------|--------|-------------|
| `[skill_name]` | [One-line description] | [How this plan affects or uses the skill] | [Trigger scenario] |

### 3.3 Other .cursor/ Files

| File | Purpose | Impact |
|-----|---------|--------|
| `rules.mdc` / `rules.md` | Rule index | [Impact] |

---

## 4. Risk & Issue Hotspots

[List potential issues, conflicts, or areas of concern.]

### 4.1 High Risk

| Area | Issue | Possible Cause | Mitigation |
|------|-------|----------------|------------|
| [Area] | [Issue description] | [Root cause] | [How to avoid or fix] |

### 4.2 Medium Risk

| Area | Issue | Possible Cause | Mitigation |
|------|-------|----------------|------------|
| [Area] | [Issue description] | [Root cause] | [How to avoid or fix] |

### 4.3 Low Risk / Notes

- [Note 1]
- [Note 2]

---

## 5. Checklist Before Implementation

- [ ] `.cursor/` rules and skills reviewed for alignment
- [ ] Dependencies and affected modules identified
- [ ] Risk mitigations planned for high/medium items
- [ ] Naming and structure follow project conventions
```

---

## Step 4: Execution Flow

1. Parse the user's prompt
2. Generate filename → `docs/<name>_plan.md`
3. Read all relevant `.cursor/` files
4. Draft content using the template
5. Write to `docs/<generated_filename>.md`
6. Summarize for the user: filename created, plan name, and main impact/risk highlights

---

## Quick Reference: .cursor/ Layout

```
.cursor/
├── rules.mdc          # Authoritative rule file index
├── rules.md           # Short human-readable index (optional)
├── rules/             # *.mdc rule bodies
├── skills/            # <skill_name>/SKILL.md
└── plans/             # Optional ad-hoc plans
```

Adapt the impact tables to the actual rules and skills present in the project (use `Glob` on `.cursor/rules/*.mdc` and `.cursor/skills/**/SKILL.md`).
