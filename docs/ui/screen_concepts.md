# Screen Concepts

置き時計アプリの現在の画面方針です。

対象:

- 古いiPhone
- 古いiPad
- 古いiPad mini
- UIKit
- iOS 12世代
- Portrait and landscape

## Main Screen: Analog Calendar Split

左に丸時計、右に月間カレンダーを置く最小画面。

以下の図は配置イメージ。実際の時計は正円を維持する。

```text
+------------------------------------------------------------------+
|                                                                  |
|          +-------------------+       May 2026                    |
|          |                   |     Su Mo Tu We Th Fr Sa          |
|          |         /         |      1  2  3  4  5  6  7          |
|          |        o--        |      8 [9]10 11 12 13 14          |
|          |                   |     15 16 17 18 19 20 21          |
|          +-------------------+     22 23 24 25 26 27 28          |
|                                  29 30 31                         |
|                                                                  |
+------------------------------------------------------------------+
```

### Layout

- 横向きでは左側にアナログ時計、右側に月間カレンダー
- 縦向きでは上側にアナログ時計、下側に月間カレンダー
- 今日の日付だけ青い丸で強調
- 右上に小さく薄い `i` ボタンを置く
- 縦向きと横向きの両方に対応する

### Device Behavior

- iPhone landscape: 時計を左45%、カレンダーを右55%程度
- iPad mini landscape: 時計を左42%、カレンダーを右58%程度
- iPad landscape: 時計を左40%、カレンダーを右60%程度
- iPhone portrait: 時計を上40%、カレンダーを下60%程度
- iPad mini portrait: 時計を上38%、カレンダーを下62%程度
- iPad portrait: 時計を上36%、カレンダーを下64%程度
- 丸時計は正円を維持し、余白で調整する

### Visual Style

- 暗い背景
- 時計の外周、数字、目盛り、針を表示する
- 秒針は赤にする
- カレンダー通常日は低コントラストにする
- 日曜は赤、土曜は青にする
- 今日だけ青い丸で強調し、日付文字は白にする

### Strength

- ユーザー要件に対して最短
- 機能が増えない
- 古い端末でも軽い
- iPhoneとiPadの両方で成立しやすい

### Risk

- iPhone横向きではカレンダーが小さくなりやすい
- iPhone縦向きでは月間カレンダーの縦密度が高くなりやすい
- 丸時計とカレンダーの視覚的な重さの調整が必要
- 今日の青い強調が強すぎると夜間に目立ちすぎる
- 右上ボタンが大きすぎると主表示の邪魔になる

## Prototype Notes

- Use Auto Layout with a horizontal split in landscape and a vertical stack in portrait
- Keep the clock face square within the left area
- Calendar should be a simple grid, not a scrollable component
- Today highlight should be a simple filled circle
- Settings live on a separate screen
- Status bar should not be required for layout

## Settings Screen

- Fullscreen sheet style
- Two groups only:
  - `Display Mode`: `Light`, `Dark`
  - `Week Starts On`: `Sunday`, `Monday`, `Saturday`
- English labels only
- No extra app options
