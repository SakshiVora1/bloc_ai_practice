---
name: error-handling-pattern
description: Apply consistent error handling and propagation patterns. Use when designing failure states, retries, and user feedback flows.
---

# Error Handling Pattern

Use this skill when implementing or refining how failures are captured, transformed, and surfaced to users.

## Use when

- Defining domain-level failure models.
- Mapping network/platform exceptions into user-facing states.
- Adding retry or fallback behavior for unstable operations.

## Suggested approach

1. Normalize low-level exceptions into typed failure objects.
2. Keep logging, telemetry, and user messaging concerns separated.
3. Ensure UI-facing layers receive actionable error information.
