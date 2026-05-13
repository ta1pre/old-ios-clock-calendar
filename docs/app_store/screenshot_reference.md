# Screenshot Reference

このファイルは、App Store向けスクリーンショットの**確定リファレンス**をまとめるためのメモです。

## Approved Japanese Reference

- Approved version: `ja_reference_v10`
- Approved slide path:
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/ja_reference_final/ja-slide-01.png`
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/ja_reference_final/ja-slide-02.png`
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/ja_reference_final/ja-slide-03.png`
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/ja_reference_final/ja-slide-04.png`
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/ja_reference_final/ja-slide-05.png`
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/ja_reference_final/ja-contact-sheet.png`

## Approved English Reference

- Approved version: `en_reference_v4`
- Approved slide path:
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/en_reference_final/en-slide-01.png`
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/en_reference_final/en-slide-02.png`
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/en_reference_final/en-slide-03.png`
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/en_reference_final/en-slide-04.png`
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/en_reference_final/en-slide-05.png`
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/en_reference_final/en-contact-sheet.png`

## Current Multilingual Reference Set

- `en` -> `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/en_reference_final/`
- `ja` -> `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/ja_reference_final/`
- `ko-KR` -> `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/ko-KR_reference_final/`
- `de-DE` -> `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/de-DE_reference_final/`
- `fr-FR` -> `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/fr-FR_reference_final/`
- `zh-Hant` -> `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/zh-Hant_reference_final/`
- `it-IT` -> `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/it-IT_reference_final/`
- `nl-NL` -> `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/nl-NL_reference_final/`
- `es-ES` -> `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/es-ES_reference_final/`
- `pt-BR` -> `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/pt-BR_reference_final/`

## Tracked Archive

- Git-tracked reference archive:
  - `/Users/taichiumeki/projects/clockApp/artifacts/app_store/reference/`
- Git-tracked review sheet:
  - `/Users/taichiumeki/projects/clockApp/artifacts/app_store/reviews/all-reference-contact-sheets.png`

The `tmp/` paths remain the working output. The `artifacts/` paths are the stored final reference set.

## Layout Rules

- Reference size: `1920 x 1080`
- App screen time is fixed to `10:10`
- Use the same device layout across locales unless there is a strong reason to change it
- Do not add decorative backgrounds or support UI that the user has removed during review

## Slide Notes

### Slide 1
- Hero page for the core product idea
- Left: headline + 3 value bullets
- Right: light iPad + dark phone

### Slide 2
- Offline / no network page
- Left: headline + support copy
- Right: dark iPad + light phone

### Slide 3
- Light / dark readability comparison
- Four devices only: light iPad, light phone, dark iPad, dark phone
- No top black panel
- No bottom switch cards

### Slide 4
- Week-start settings page
- Show settings UI clearly

### Slide 5
- Reuse / second-life message
- No lower scene cards

## English Version Policy

- English should follow the same layout as the approved Japanese reference
- English copy should be **adapted**, not literal
- Priority is natural App Store phrasing, not line-by-line equivalence

## Submission Export

- Export script:
  - `/Users/taichiumeki/projects/clockApp/tools/export_app_store_submission_sizes.py`
- Submission root:
  - `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/submission/`

### Current export sizes

- `iphone_6_9_landscape`: `2796 x 1290`
- `ipad_13_landscape`: `2752 x 2064`

### Japanese submission output

- `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/submission/ja/iphone_6_9_landscape/`
- `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/submission/ja/ipad_13_landscape/`

### English submission output

- `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/submission/en/iphone_6_9_landscape/`
- `/Users/taichiumeki/projects/clockApp/tmp/appstore_assets/submission/en/ipad_13_landscape/`
