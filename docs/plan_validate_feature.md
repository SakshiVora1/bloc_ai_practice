[//]: # (# 🔍 Feature Plan Validator)

[//]: # ()
[//]: # (> **Plan File:** `{{PLAN_FILE_PATH}}`)

[//]: # ()
[//]: # (---)

[//]: # ()
[//]: # (## 🧠 AI Instructions)

[//]: # ()
[//]: # (1. Read the plan file)

[//]: # (2. Validate against:)

[//]: # ()
[//]: # (   * `.cursor/rules.md`)

[//]: # (   * `.cursor/rules/`)

[//]: # (   * `.cursor/skills/`)

[//]: # (---)

[//]: # ()
[//]: # (## ✅ Validation Checklist)

[//]: # ()
[//]: # (* Correct folder structure)

[//]: # (* Proper bloc usage)

[//]: # (* Routing defined correctly)

[//]: # (* No missing layers)

[//]: # (* Constants usage defined)

[//]: # (* Config usage correct)

[//]: # (* No architecture violations)

[//]: # ()
[//]: # (---)

[//]: # ()
[//]: # (## ⚠️ Output Format)

[//]: # ()
[//]: # (* ✅ Valid sections)

[//]: # (* ❌ Issues found)

[//]: # (* 🔧 Suggested fixes)

[//]: # ()
[//]: # (---)

[//]: # ()
[//]: # (## 📌 Final Instruction)

[//]: # ()
[//]: # (* Do NOT generate code)

[//]: # (* Only validate and suggest improvements)


# 🔍 Feature Plan Validator + Auto-Fix

> **Plan File:** `{{PLAN_FILE_PATH}}`

---

## 🧠 AI Instructions

1. Read the plan file

2. Validate against:

   * `.cursor/rules.mdc`
   * `.cursor/rules/`
   * `.cursor/skills/`

3. Identify:

   * Valid sections
   * Issues
   * Deviations

4. Automatically FIX:

   * Missing justifications
   * Minor inconsistencies
   * Rule alignment issues

5. Update the plan file with fixes

---

## ✅ Validation Logic

* ✅ Rule followed → keep as-is
* ⚠️ Deviation with no justification → ADD justification
* ❌ Real issue → FIX it directly

---

## 🔧 Auto-Fix Rules (VERY IMPORTANT)

### 1. BLoC State Lifecycle

If standard states (loading/success/error) are missing:

* Check if feature requires them

* If NOT required:
  → Add justification:

  "This feature does not include loading or error states because it does not involve API or asynchronous operations."

* If required but missing:
  → Update plan to include them

---

### 2. Error Handling

If error handling is missing:

* If feature has no failure scenario:
  → Add justification

* If feature has API/logic:
  → Add error handling section

---

### 3. Folder Structure Issues

* Fix incorrect folder placement
* Remove unnecessary folders
* Align with project structure rules

---

### 4. Missing Clarifications

Auto-add where needed:

* Placeholder features:
  → "This is a placeholder implementation; full bloc will be added later"

* Partial implementations:
  → Clarify scope

---

### 5. Bloc File Structure

If missing:
→ Add note:

"Bloc uses part/part of structure for events and states"

---

### 6. Routing Issues

* Fix incorrect route naming
* Ensure proper registration flow

---

## ⚠️ Restrictions

* ❌ Do NOT change feature logic
* ❌ Do NOT over-engineer
* ❌ Do NOT add unnecessary layers
* ✅ Only fix alignment + clarity issues

---

## 📋 Output Format

### ✅ Valid Sections

* List sections that required no changes

---

### 🔧 Auto-Fixes Applied

* List all fixes made
* Show what was added/modified

---

### ⚠️ Remaining Issues (if any)

* Only include issues that require human decision

---

## 📁 Final Instruction

* Update the plan file directly
* Ensure formatting remains clean
* Keep plan readable and structured

