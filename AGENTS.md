# Project Agent Rules

このプロジェクトは、古いiPhone / iPad / iPad mini で使う「置き時計アプリ」の学習用ワークスペースです。

現段階の目的は、古い端末で見やすく使いやすい **時計表示 + カレンダー + 最小設定画面** をUIKitで成立させることです。

## Current Scope

- UIKitベースで実装する
- iOS 12世代の古い端末を基準にする
- 対象は古いiPhone、iPad、iPad mini
- 縦向きと横向きの両方に対応する
- 横向きでは左にアナログ時計、右に月間カレンダー
- 縦向きでは上にアナログ時計、下に月間カレンダー
- アナログ時計は、数字あり、目盛りあり、赤い秒針ありの見た目を基準にする
- カレンダーでは日曜を赤、土曜を青、今日の日付を青い丸で示す
- 設定画面は `Light` / `Dark` と `Sunday` / `Monday` / `Saturday` のみ
- 設定画面の表示文言は英語のみ
- 設定値は端末内に保存してよい
- アラーム、通知、予定表示、祝日表示、天気、メモ、App Store対応はまだ扱わない
- SwiftUIは使わない
- WebViewを前提にしない
- 追加機能を勝手に増やさない

## How Codex Should Work

Codexは作業中、ユーザーが学習できるように以下を短く説明しながら進める。

- いま何を確認しているか
- なぜその確認が必要か
- どの判断をしたか
- 次に何をするか
- サブエージェントを使う場合、何を依頼したか
- サブエージェントの結果をどう採用または保留したか

説明は長文にしすぎず、作業の節目ごとに行う。

## Documentation First

UI実装に入る前に、以下のドキュメントを確認する。

- `docs/ui/ui_direction.md`
- `docs/ui/screen_requirements.md`
- `docs/ui/screen_concepts.md`
- `docs/ui/figma.md`
- `docs/agent_checks/ios12_ui_constraints.md`
- `docs/agent_checks/ui_design_review.md`
- `docs/agent_checks/proceed_rules.md`

ドキュメントの内容と矛盾する作業をする場合は、先に理由を説明し、必要ならドキュメントを更新する。

## Sub-Agent Rules

サブエージェントは常時使うものではなく、判断やレビューの質を上げたい時に使う。

以下の場合は、必要に応じてサブエージェントを1人以上使う。

- UI方針を決める時
- 対象端末や対応OSに影響するUI技術を選ぶ時
- 置き時計としての視認性や実用性を確認する時
- 大きなレイアウト変更をする時
- 実装前に別視点のレビューが必要な時

初期フェーズでは、サブエージェントは原則1人だけ使う。ユーザーが追いやすいようにするため。

## Standard Review Pattern

UI方針レビューでは、必要に応じて以下の役割を使う。

- Main Codex: 方針を整理し、最終判断を行う
- Sub-agent: `docs/agent_checks/ui_design_review.md` と `docs/agent_checks/ios12_ui_constraints.md` に沿って、見落としや改善点をレビューする

サブエージェントに依頼する時は、依頼内容をユーザーに説明する。

## Proceed Rules

次の段階へ進む前に、`docs/agent_checks/proceed_rules.md` を確認する。

点数だけで進めない。Must項目に未解決の問題がある場合は、先に修正または保留理由を明記する。

## UI Priorities

置き時計UIでは、見た目の派手さよりも以下を優先する。

1. 左の時計表示が遠目でも読める
2. 右のカレンダーで今日の日付がすぐ分かる
3. 縦向きと横向きの両方で安定して見える
4. 古いiPhone / iPad / iPad miniで重くない
5. 設定画面はあるが、メイン画面を邪魔しない
6. 端末サイズや向きが変わってもレイアウトが破綻しない
