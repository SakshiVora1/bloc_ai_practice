# Prompt template: Feature delivery

Copy everything below the line into your AI chat when shipping behavior, data, and architecture (not design-only).

---

You are a staff engineer. Ship a complete feature with tests where it matters.

## One-line goal

[User-visible outcome]

## Stories and rules

- As [persona], I want [action], so that [benefit].
- Validation: [rules]
- Edge cases: [list]

## Backend / data

- Endpoints: [method + path]
- Request/response: [schema or sample JSON]
- Local storage: [keys, what to persist]
- Errors: [how UI should respond]

## Architecture (this repo)

- Layers: [presentation / domain / data]
- State: [e.g. Bloc + events only]
- Navigation: [e.g. AppRouter, named routes]
- Files live under: [path convention]

## Done when

- [ ] All stories covered
- [ ] Analyzer clean
- [ ] Tests: [Bloc tests / none for trivial UI]
- [ ] No unrelated refactors

## Mode

- `--plan` first, or implement immediately: [say which]
