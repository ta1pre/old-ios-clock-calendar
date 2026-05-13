# Localization Strategy

## Goal

このアプリの多言語対応は、以下の3つを同時に崩さず進める。

1. App Store テキスト
2. App Store スクリーンショット
3. Support / Privacy ページ

直訳はしない。各言語で **自然に売れる表現** を優先する。

## Source of Truth

- Shared decisions:
  - `/Users/taichiumeki/projects/clockApp/docs/app_store/decisions.md`
- Localization bundle:
  - `/Users/taichiumeki/projects/clockApp/tools/localization_bundle.py`
- Locale metadata:
  - `/Users/taichiumeki/projects/clockApp/docs/app_store/localizations/<locale>.json`
- Screenshot copy:
  - `/Users/taichiumeki/projects/clockApp/docs/app_store/screenshots_<tag>.md`
- Screenshot reference:
  - `/Users/taichiumeki/projects/clockApp/docs/app_store/screenshot_reference.md`
- Locale rollout status:
  - `/Users/taichiumeki/projects/clockApp/docs/app_store/locale_rollout.json`
- QA gate:
  - `/Users/taichiumeki/projects/clockApp/docs/app_store/localization_qc.md`

## Storage Rules

### Text

- One JSON per locale in `docs/app_store/localizations/`
- Start from `_template.json`
- Keep shared release facts identical across locales:
  - app name
  - category
  - price
  - copyright

### Screenshots

- Reference slides:
  - Working output: `tmp/appstore_assets/<tag>_reference_final/`
  - Tracked archive: `artifacts/app_store/reference/<tag>/`
- Submission sizes:
  - `tmp/appstore_assets/submission/<tag>/<family>/`

### Public Pages

- English root:
  - `site/`
- Locale pages:
  - `site/<language>/`

## Rollout Order

### Tier 0

- `en-US`
- `ja-JP`

These are done first and used as the master reference.

### Tier 1

- `ko-KR`
- `de-DE`
- `fr-FR`
- `zh-Hant`
- `it-IT`
- `nl-NL`
- `es-ES`
- `pt-BR`

These are the current multilingual release wave.

## Workflow Per Locale

1. Update `tools/localization_bundle.py`
2. Regenerate `<locale>.json`
3. Regenerate `screenshots_<tag>.md`
4. Regenerate localized reference screenshots
5. Export submission-size screenshots
6. Regenerate support/privacy pages
7. Run automated audit
8. Run text/image sub-agent review
9. Mark status in `locale_rollout.json`

## Quality Gates

Before a locale is marked done:

1. Automated audit passes
2. Text reads naturally in that language
3. No obvious literal translation artifacts
4. Screenshot text fits without clipping
5. Support and privacy URLs exist
6. App Store metadata matches the current release decisions

## Working Rule

When adding a new language, do not do all languages at once.

- First finish source copy
- Then regenerate outputs
- Then pass audit
- Then pass sub-agent review
- Then mark the locale done

This keeps the rollout trackable and prevents half-finished locales from mixing into submission work.
