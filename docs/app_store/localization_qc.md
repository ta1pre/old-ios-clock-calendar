# Localization QC Gate

このチェックは、多言語対応を「生成しただけ」で終わらせないための通過基準です。

## Text Gate

Must:

- App Name が `Old Device Clock & Calendar` で統一されている
- Subtitle が不自然な直訳になっていない
- Promotional Text / Description / Review Notes が、現在の実装事実と矛盾しない
- `offline / no account / no ads / no tracking / one-time purchase` の事実が崩れていない
- Support / Privacy / Marketing URL が存在するページを指している
- ローカライズ JSON が欠けなく生成されている

Should:

- 各言語でストア文として自然に読める
- キーワードがその言語の検索意図に沿っている
- Review Notes は審査担当が実機確認しやすい表現になっている

## Screenshot Gate

Must:

- 各言語で 5 枚の reference slide がある
- 各言語で iPhone / iPad 提出サイズがある
- すべてのスクリーンショットで時刻が `10:10`
- テキストのはみ出し、重なり、切れがない
- Slide 3 は `ライト iPad / ライト iPhone / ダーク iPad / ダーク iPhone` の 4 端末構成
- Slide 3 に不要な黒パネルや切り替えボタンがない
- Slide 5 は現在の確定コピーとレイアウトに一致する

Should:

- 日本語確定版のトーンから大きく外れていない
- 端末や背景のコントラストで文字が沈んでいない
- 長い言語でも余白が不自然に詰まりすぎていない

## Storage Gate

Must:

- `docs/app_store/localizations/` に locale ごとの JSON がある
- `docs/app_store/screenshots_<tag>.md` に locale ごとのスクショ文言がある
- `site/` 配下に locale ごとの support / privacy / home がある
- `tmp/appstore_assets/<tag>_reference_final/` に reference 画像がある
- `tmp/appstore_assets/submission/<tag>/` に提出サイズ画像がある

## Review Rule

- 自動チェックを先に通す
- その後、**テキスト確認サブエージェント** と **画像確認サブエージェント** の両方を通す
- どちらかが `fail` を返したら、その locale は差し戻し
- 両方 `pass` になった locale だけ `done`
