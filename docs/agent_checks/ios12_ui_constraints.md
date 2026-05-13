# iOS 12 UI Constraints

このチェックは、古いiPhone / iPad / iPad miniで動かすUIKit UIプロトタイプのための制約確認です。

## Must

- SwiftUIを使わない
- UIKitで画面を構成する
- iOS 13以降専用のAPIに依存しない
- SF Symbolsを必須UIとして使わない
- Dynamic TypeやAuto Layoutを使う場合も、iOS 12で使える範囲にする
- ダークモードAPIを前提にしない
- 縦向きと横向きの両方を iOS 12 世代の Auto Layout で成立させる
- iPhone landscape 667 x 375 pt から iPad landscape 1024 x 768 pt まで破綻しないようにする
- iPhone portrait 375 x 667 pt から iPad portrait 768 x 1024 pt まで破綻しないようにする
- 568 x 320 pt と 320 x 568 pt は最小iPhoneの破綻リスク確認対象として扱う
- アナログ時計は正円を維持する
- アナログ時計は数字、目盛り、秒針を表示してもよい
- カレンダーは7列 x 最大6行で表示できるようにする
- メイン画面の追加ボタンは右上の設定ボタン1つに限定する
- 設定画面は `Light` / `Dark` と `Sunday` / `Monday` / `Saturday` に限定する

## Should

- Auto Layoutで横向きは左右2カラム、縦向きは上下2段にする
- iPhone横向きではカレンダー文字が小さすぎないようにする
- iPadでは余白を広げ、要素が間延びしないようにする
- 複雑なアニメーションや重い描画を避ける
- 古い端末で線や文字が細く見えすぎないようにする
- 実際の画面輝度制御はこの段階では対象外とし、低輝度配色で検討する
- 実機配布前に署名設定が必要であることを別問題として切り分ける

## Avoid

- iOS 13以降の`UIUserInterfaceStyle`前提のテーマ切り替え
- iOS 13以降の`UIColor` dynamic provider前提の色設計
- SwiftUI view
- Combine
- WidgetKit
- SceneDelegate必須構成
- WebViewをUIの中心にする構成
- `Follow System` のようなiOS 13前提のテーマ項目

## Review Questions

- このUIは古いiPhone縦向き・横向きで読めるか
- iPad / iPad miniで余白が不自然にならないか
- iOS 12非対応APIを前提にしていないか
- 時計表示とカレンダーだけにスコープが保たれているか
- 今日の日付の青い強調が強すぎないか
- 設定画面が古い縦向き・横向き端末でも収まるか
