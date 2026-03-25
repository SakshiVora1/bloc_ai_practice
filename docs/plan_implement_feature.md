# 🛠️ Feature Implementation Generator

> **Feature Plan File:** `{{PLAN_FILE_PATH}}`

---

## 🧠 AI Instructions

You are an expert Flutter developer.

Your task is to:

1. Read the feature plan from:
   `{{PLAN_FILE_PATH}}`

2. Follow strictly:

    * `.cursor/rules.mdc`
    * `.cursor/rules/`
    * `.cursor/skills/`

3. Convert the plan into **production-ready Flutter code**

---

## ⚠️ Mandatory Constraints

* ✅ Follow flutter_bloc pattern
* ✅ Follow project folder structure (from rules)
* ✅ Maintain separation of concerns
* ❌ Do NOT deviate from plan
* ❌ Do NOT invent new architecture
* ❌ Do NOT skip layers defined in plan

---

⚠️ Implementation Confirmation Rule

- Before starting implementation, the AI MUST:

- Show a brief summary of the plan
- Ask: "Do you want to proceed with implementation? (yes / no)"

Only proceed if the user explicitly replies yes

## 📁 File Creation Rules

* Create all required files as per plan
* Place files in correct folders
* Do NOT create unnecessary files

---

## 🧩 Implementation Requirements

### 1. Bloc Layer

* Create:

    * Bloc
    * Events
    * States
* Ensure:

    * Proper event handling
    * Clean state transitions

---

### 2. UI Layer

* Build screen UI
* Connect Bloc using:

    * BlocProvider
    * BlocBuilder / BlocListener
* Keep UI clean and modular

---

### 3. Repository Layer

* Implement repository logic
* Handle:

    * API calls (if required)
    * Model parsing
* Return models directly (as per architecture)

---

### 4. Models

* Create model classes (if required)
* Ensure:

    * Proper null safety
    * JSON parsing (if needed)

---

### 5. Routing

* Register route in:

    * app_routes.dart
    * route_names.dart
* Add navigation logic

---

### 6. Constants Usage

* Use existing constants
* Do NOT hardcode values

---

### 7. Config Usage

* Use URL/config from central config
* Do NOT hardcode URLs

---

## 🔍 Validation Before Final Output

* Check folder placement
* Check bloc structure
* Check UI-bloc connection
* Check routing correctness
* Ensure no hardcoding

---

## 📌 Final Output

* Generate complete code
* Ensure clean formatting
* Ensure production-ready quality
