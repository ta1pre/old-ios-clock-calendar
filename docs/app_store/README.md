# App Store Localization Workflow

This folder is the source of truth for App Store submission text.

## Current default

- Default language: `en-US`
- Initial secondary language: `ja-JP`

## Structure

- `decisions.md`
  - Shared release decisions that should not drift by locale.
- `localizations/<locale>.json`
  - Locale-specific App Store metadata.
- `release_checklist.md`
  - Submission checklist.

## How to add a new locale

1. Copy `en-US.json` to a new locale file.
2. Translate only user-facing strings.
3. Keep shared properties aligned with `decisions.md`.
4. Add matching support/privacy pages under `site/<language>/` when needed.

## Notes

- Root `site/` is English.
- `site/ja/` is Japanese.
- Replace the placeholder email before publishing.
