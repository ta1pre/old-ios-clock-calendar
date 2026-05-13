# 実機インストール手順

このアプリは、シミュレータでは起動確認済みです。

古い `iPhone / iPad / iPad mini` に入れるには、XcodeにAppleアカウントを追加して、署名設定を1回だけ行います。

## いまの状態

- `iOS 12.0` を下限にしたビルド設定になっている
- シミュレータでは起動確認済み
- 実機用の署名設定だけ未完了
- Bundle Identifier は `com.taichiumeki.analogcalendarclock`

## 1. AppleアカウントをXcodeに追加する

1. Xcodeを開く
2. 上のメニューで `Xcode` -> `Settings...`
3. 左の `Apple Accounts`
4. `Add Apple Account...`
5. 自分のApple IDでサインイン

ここはユーザー本人の操作が必要。

## 2. 実機をMacにつなぐ

1. 古いiPhoneまたはiPadをUSBでMacにつなぐ
2. 端末側で「このコンピュータを信頼」を許可する
3. パスコードを求められたら入力する

## 3. Teamを選ぶ

1. Xcode左の `AnalogCalendarClock` を押す
2. 真ん中上の `TARGETS` で `AnalogCalendarClock` を押す
3. `Signing & Capabilities` を開く
4. `Team` に、自分のAppleアカウントのチームを選ぶ

通常は `Personal Team` でよい。

## 4. 実機を起動先にする

1. Xcode上部の端末名を押す
2. 接続した `iPhone` または `iPad` を選ぶ
3. 左上の `Run` を押す

## 5. 端末側で初回許可する

初回だけ、端末側で開発元の許可が必要になることがある。

その場合は端末側で:

1. `Settings`
2. `General`
3. `VPN & Device Management`
4. 自分のApple IDを信頼

## 実機で見るべき点

- 横向きで固定されるか
- 左の時計が十分大きいか
- 右のカレンダーが読めるか
- `Light / Dark` が切り替わるか
- `Sunday / Monday / Saturday` が反映されるか
- 長押しで設定画面が開くか

## いまのブロッカー

このMacのXcodeには、まだAppleアカウントが追加されていない。

そこだけ終われば、実機インストール作業を続けられる。
