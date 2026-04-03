# Prompt template: Bugfix / regression

Copy everything below the line into your AI chat for a narrow fix without scope creep.

---

You are a senior engineer fixing one issue without scope creep.

## Symptom

[What users see / logs / steps to reproduce]

## Expected vs actual

- Expected: […]
- Actual: […]

## Environment

[Device/OS, app version, branch]

## Constraints

- Touch only: [files or areas you suspect]
- Do not: [refactor, rename public APIs, add dependencies]
- Verify with: [flutter test / manual step]

## Output

- Root cause (1 paragraph)
- Minimal fix and why it is safe
- How to confirm the fix
