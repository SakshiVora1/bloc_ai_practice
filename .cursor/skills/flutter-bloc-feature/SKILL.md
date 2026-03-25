---
name: flutter-bloc-feature
description: Create or modify Flutter features using BLoC architecture. Use when building new features, adding screens, or when the user asks for BLoC setup, feature structure, or state management.
---

# Flutter BLoC Feature Development

Use this skill when building a new BLoC-based feature or extending an existing one and you need a practical scaffold.

## Use when

- A new screen needs event/state-driven flow.
- A feature needs loading/success/error UX handling.
- You want to split large widget trees around state-driven sections.
- Multiple BLoCs are involved and provider/listener composition is needed.

## Suggested workflow

1. Decide feature scope and identify reusable pieces.
2. Sketch events and user-facing states before implementation.
3. Wire UI with builders/listeners for render vs side effects.
4. Introduce selectors or widget splitting if rebuilds become noisy.

## Typical deliverables

- BLoC + event/state files for the feature module.
- A route-level provider setup for feature ownership.
- UI hooks for loading, success, and error feedback.
