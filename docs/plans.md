# 🧩 Feature Plan Generator (File-Based)

> **Feature Prompt:** *{{FEATURE_PROMPT}}*

---

## 🧠 AI Instructions

You are an expert Flutter architect.

Your task is to:

1. Analyze the feature prompt
2. Read and strictly follow:

    * `.cursor/rules.mdc`
    * `.cursor/rules/`
    * `.cursor/skills/`
3. Identify relevant rules and skills required for this feature
4. Generate a **structured implementation plan**
5. Create and save the plan as a **Markdown file**

---

## 📁 File Creation Rules

* Create file inside:

  `docs/plans/{{feature_name}}_plan.md`

* Naming rules:

    * Use snake_case
    * Keep it short and meaningful
    * Examples:

        * splash_screen_plan.md
        * login_feature_plan.md

* If file already exists:

    * Update the existing file
    * Do NOT create duplicates

---

## ⚠️ Mandatory Constraints

* ❌ Do NOT write implementation code
* ❌ Do NOT redefine full project structure
* ❌ Do NOT invent new architecture
* ✅ Only write plan
* ✅ Follow flutter_bloc pattern
* ✅ Follow clean architecture
* ✅ Use existing project rules as source of truth

---

## 📄 Plan Structure (Must Follow)

### 1. Purpose

* Goal of feature
* Problem it solves

---

### 2. Feature Flow

* Step-by-step user flow

---

### 3. Folder Structure (Rule-Based)

* Do NOT define full structure
* Only include:

    * Files/folders that will be CREATED or USED
* Must follow project structure defined in rules/skills

---

### 4. Bloc Strategy

* Bloc(s) required
* Events
* States
* Responsibility of each bloc

---

### 5. Routing

* Route name
* Navigation flow (from → to)
* Where BlocProvider is placed:

    * Global OR
    * Route-level

---

### 6. UI Breakdown

* Screen structure
* Components
* Reusable widgets (if any)

---

### 7. Data Flow

UI → Bloc → Repository → UI

* No separate data source layer is used
* Repository is responsible for:

    * Network/API calls
    * Model creation and parsing
    * Request payload preparation (e.g., encryption/signing if required)
* Models are returned directly from repository
* Bloc converts response into states

---

### 8. Constants & Theme

* Existing constants to use
* Any new constants required
* Theme usage (colors, text styles)

---

### 9. Configuration

* API usage (if needed)
* `.env` / config usage

---

### 10. Dependencies

* Bloc dependencies
* Repository injection
* External packages (if required)

---

### 11. Edge Cases

* Loading state
* Error handling
* Empty states
* Navigation edge cases
* Input validation edge cases (regex, min/max length, strength rules)

---

### 12. Rule Compliance Check

Verify:

* No hardcoding
* Correct folder placement
* Proper bloc usage
* Routing consistency
* Config usage
* Separation of concerns

---

### 13. Scalability

* How feature can scale
* Reusable components
* Future enhancements

---

## 🔍 Structure Validation (MANDATORY)

Before finalizing the plan:

* Ensure feature follows defined folder structure

* Ensure:

    * Bloc is in correct location
    * Repository is in correct layer
    * Models are correctly separated:

        * API → data/models/
        * UI → feature models/

* Ensure no extra/unnecessary folders are created

* Fix any violations before final output

---

## ⚠️ Anti-Deviation Rule

* Do NOT override project rules
* Do NOT create new patterns
* If conflict occurs:
  → Follow `.cursor/rules.mdc` as source of truth

---

## 📌 Final Instruction

After generating the plan:

✅ Create or update the file
✅ Insert the complete plan
✅ Ensure formatting is clean, structured, and readable
