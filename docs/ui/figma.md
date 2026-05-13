# Figma Design File

このプロジェクトのUI検討用Figmaファイル。

URL:

- https://www.figma.com/design/2r0RgMnxATLUCNv15zdacK

## Frames

Figma MCPのStarterプラン上限に当たったため、最新フレームIDは未取得。Figma上の過去比較案は残っているが、現在の実装方針は以下を基準にする。

- Analog Calendar Split
- Settings Screen

各行に以下の4サイズを配置。

- `iPhone Small Landscape / 568 x 320`
- `iPhone 6 Landscape / 667 x 375`
- `iPad mini Landscape / 1024 x 768`
- `iPad Landscape / 1024 x 768`

## Purpose

Figmaでは、古いiPhone / iPad / iPad mini向けの横置きUIの見た目を確認する。

表示するもの:

- 左: 時計表示
- 右: 月間カレンダー
- 今日の日付だけ青い丸で強調

## Visual Style

- 背景は黒に近い暗色
- 時計は数字、目盛り、赤い秒針を含む
- カレンダーは通常日を抑え、日曜を赤、土曜を青にする
- 今日の日付は青い丸 + 白文字で強調する
- 設定画面は `Light` / `Dark` と `Sunday` / `Monday` / `Saturday`

Figmaは見た目の検討用。実機での横向き固定、スリープ制御、iOS 12動作はUIKit側で確認する。
