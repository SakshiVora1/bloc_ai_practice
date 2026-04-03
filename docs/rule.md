# Rules vs skills (this repo)

**Authoritative:** **`.cursor/rules.mdc`** → individual **`.cursor/rules/*.mdc`** files, plus **`AGENTS.md`**.

- **Rules** (`.mdc` under **`.cursor/rules/`**): mandatory Flutter/BLoC, routing, repositories, assets, env URLs, serialization.
- **Skills** (remaining under **`.cursor/skills/`**): optional workflows only:
  - **`device-type-detection`**
  - **`flutter-package-install`**
  - **`prompt-to-docs-plan`**
  - **`shared-preferences-storage`**

Feature layout, constants, environment URLs, repository pattern, and error/toast flow live in **rules** (especially **`flutter-development.mdc`**, **`bloc-patterns.mdc`**, **`repository-boundaries.mdc`**, **`environment-urls.mdc`**, **`flutter-assets.mdc`**). Duplicated skill files for those topics were removed.
