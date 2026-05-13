# App Store Localization Workflow

This folder is the source of truth for App Store submission text.

## Current default

- Default language: `en-US`
- Initial secondary language: `ja-JP`

## Structure

- `../tools/localization_bundle.py`
  - Source bundle for multilingual App Store text, screenshot copy, and page copy.
- `localization_qc.md`
  - Pass/fail gate for text, screenshots, and storage coverage.
- `decisions.md`
  - Shared release decisions that should not drift by locale.
- `localization_strategy.md`
  - Rollout order, storage rules, and QA gates for multi-language work.
- `locale_rollout.json`
  - Per-locale progress tracker.
- `localizations/<locale>.json`
  - Locale-specific App Store metadata.
- `localizations/_template.json`
  - Starting point for a new locale.
- `release_checklist.md`
  - Submission checklist.
- `screenshots_<locale>.md`
  - Locale-specific screenshot copy.
- `reviews/localization_audit.md`
  - Automated pass/fail summary before sub-agent review.
- `../artifacts/app_store/reference/`
  - Git-tracked final reference screenshots by locale.

## How to add a new locale

1. Add locale copy to `tools/localization_bundle.py`.
2. Run the localization sync so metadata JSON, screenshot docs, and public pages are regenerated.
3. Regenerate reference screenshots and submission exports.
4. Copy approved reference screenshots into `artifacts/app_store/reference/`.
5. Run the automated audit.
6. Run text and image sub-agent review.
7. Update `locale_rollout.json` only after all gates pass.

## Notes

- Root `site/` is English.
- `site/ja/` is Japanese.
- Additional locales use locale-coded folders such as `site/de-DE/`.
