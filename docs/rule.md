Refactor the provided Rules and Skills configuration into a strictly separated, production-ready agentic AI system.

### Hard Constraints (MUST FOLLOW)

1. **Strict Separation**

    * Rules = mandatory, non-negotiable constraints
    * Skills = optional, context-based capabilities
    * No overlap allowed

2. **Automatic Reclassification**

    * Any statement containing “must”, “always”, “do not” → move to Rules
    * Any optional or situational logic → move to Skills

3. **No Duplication**

    * Each concept must exist in only one place
    * If duplicated across files, keep a single source of truth and remove others

4. **Rules Requirements**

    * Short, strict, enforceable
    * No explanations unless absolutely necessary
    * Written only as constraints

5. **Skills Requirements**

    * Must NOT enforce behavior
    * Must be decision-based (“use when…”, “applies when…”)
    * Must enhance flexibility

6. **Mixed Files Handling**

    * If a file contains both rules and skills:

        * Extract rules → `/cursor/rules/`
        * Extract skills → `/cursor/skills/`
        * Do not leave mixed content

---

### Target File Structure (APPLY CHANGES HERE)

#### ✅ Rules (Modify only inside this path)

* `/cursor/rules/bloc-patterns.md`
* `/cursor/rules/environment-urls.md`
* `/cursor/rules/flutter-assets.md`
* `/cursor/rules/general.md`
* `/cursor/rules/project-structure.md`
* `/cursor/rules/routing-conventions.md`
* `/cursor/rules.md` (index only, no logic duplication)

#### ❌ Remove from Skills (delete completely)

* `/cursor/skills/flutter-app-constants/`
* `/cursor/skills/flutter-project-structure/`
* `/cursor/skills/flutter-environment-url/` *(if containing rules)*

#### ⚠️ Refactor (modify content)

* `/cursor/skills/flutter-bloc-feature/SKILL.md`

    * Keep only decision-based guidance
    * Remove all strict rules (move them to bloc-patterns.md)

#### ✅ Keep as Skills (no strict rules inside)

* `/cursor/skills/flutter-package-install/SKILL.md`

---

### ➕ Add New Skills (create folders + SKILL.md)

* `/cursor/skills/device-type-detection/SKILL.md`
* `/cursor/skills/shared-preferences-storage/SKILL.md`
* `/cursor/skills/api-repository-pattern/SKILL.md`
* `/cursor/skills/error-handling-pattern/SKILL.md`

---

### 📦 Move Non-Rule Files

* Move:

    * `/cursor/project_consistency_plan.md`

  👉 to:

    * `/docs/project_consistency_plan.md`

---

### Output Requirements

* Section 1: Final Rules (from `/cursor/rules/`)
* Section 2: Final Skills (from `/cursor/skills/`)
* Maintain folder-based modular structure
* Do not include explanations
* Do not duplicate content
* Ensure strict agentic separation

### Goal

* Rules strictly control AI behavior
* Skills enable intelligent, context-based decisions
