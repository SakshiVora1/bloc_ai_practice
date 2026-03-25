---
name: api-repository-pattern
description: Structure API access behind repository abstractions. Use when adding endpoints, data sources, or feature data orchestration.
---

# API Repository Pattern

Use this skill when network-backed data must be integrated into features with clear separation from UI flow code.

## Use when

- Adding a new endpoint integration.
- Refactoring direct API usage out of presentation code.
- Standardizing response-to-model mapping across features.

## Suggested approach

1. Keep API clients focused on request/response mechanics.
2. Use repositories to translate raw responses into domain-ready models.
3. Return typed results that presentation layers can consume predictably.
