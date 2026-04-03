# Plan: {{TITLE}}

> **Prompt (argument):** _[Insert the user prompt / argument here when creating a plan]_

---

## 1. Purpose

_[Describe the purpose and goal of this plan. What problem does it solve? What outcome are we aiming for?]_

---

## 2. Rules & Skills Reference

_This section summarizes the rules and skills defined in the `.cursor` folder. All implementation must align with these._

### 2.1 Rules (`.cursor/rules/*.mdc`)

See **`.cursor/rules.mdc`** for the full index. Commonly used:

| Rule | Role |
|------|------|
| **general.mdc** | Reuse, naming, `snake_case` files |
| **flutter-development.mdc** | BLoC-only state, feature layout, API flow, **AppToast** |
| **bloc-patterns.mdc** | Events/states, `response_type`, listeners |
| **repository-boundaries.mdc** | Repositories → **ApiService** only; no UX branching |
| **routing-conventions.mdc** | **RouteNames**, **AppRoutes.routes** |
| **environment-urls.mdc** | **AppConfig**, **UrlService**, no hardcoded URLs |
| **flutter-assets.mdc** | **AppAssets**, **AppStrings**, **AppColors**, **AppFonts** |
| **model-serialization.mdc** | JSON models, **`data/`** placement |

### 2.2 Skills (`.cursor/skills/` — optional workflows only)

| Skill | When to Use |
|-------|-------------|
| **flutter-package-install** | `flutter pub add`, `flutter pub get` |
| **prompt-to-docs-plan** | Plan / impact docs under **`docs/`** |
| **shared-preferences-storage** | Local key-value persistence |
| **device-type-detection** | Responsive / form-factor behavior |

---

## 3. Detailed Approach

### 3.1 Overview

_[High-level description of how the plan will be executed. What are the main phases or steps?]_

### 3.2 Step-by-Step Strategy

1. **[Step 1 name]**  
   - _Description_
   - _Expected outcome_

2. **[Step 2 name]**  
   - _Description_
   - _Expected outcome_

3. **[Step 3 name]**  
   - _Description_
   - _Expected outcome_

_[Add more steps as needed]_

### 3.3 Technical Considerations

- **Architecture:** _[How does this fit into the existing BLoC / feature structure?]_
- **Dependencies:** _[New packages? Changes to pubspec?]_
- **Constants / Assets:** _[New entries in AppAssets, AppStrings, AppColors, AppFonts?]_
- **Routing:** _[New routes in RouteNames / AppRoutes?]_
- **Environment / URLs:** _[Any URL or config changes?]_

---

## 4. Risks & Mitigation

| Risk | Severity | Mitigation |
|------|----------|------------|
| _[Risk 1]_ | High / Medium / Low | _[How to mitigate]_ |
| _[Risk 2]_ | High / Medium / Low | _[How to mitigate]_ |
| _[Risk 3]_ | High / Medium / Low | _[How to mitigate]_ |

_[Add more as needed]_

---

## 5. Risk Hotspots

_List files, directories, or areas of the codebase that are most likely to be affected or require extra care:_

- `lib/` — _[Description]_
- `.cursor/` — _[Impact on rules or skills?]_
- `pubspec.yaml` — _[New dependencies?]_
- _[Other areas]_

---

## 6. .cursor Impact

| Area | Impact | Action |
|------|--------|--------|
| **Rules** | _[None / Low / Medium / High]_ | _[Any rule updates needed?]_ |
| **Skills** | _[None / Low / Medium / High]_ | _[Any skill updates needed?]_ |
| **AGENTS.md** | _[None / Low / Medium / High]_ | _[Any agent instruction changes?]_ |

---

## 7. Success Criteria

- [ ] _[Criterion 1]_
- [ ] _[Criterion 2]_
- [ ] _[Criterion 3]_

---

## 8. Out of Scope

_[What is explicitly NOT part of this plan?]_

---

## 9. Notes & Assumptions

- _[Assumption 1]_
- _[Assumption 2]_
- _[Note 1]_

---

## 10. References

- [AGENTS.md](../AGENTS.md)
- [.cursor/rules.md](../.cursor/rules.md)
- [.cursor/project_consistency_plan.md](../.cursor/project_consistency_plan.md)
