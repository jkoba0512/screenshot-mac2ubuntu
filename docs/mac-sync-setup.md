# Mac → Ubuntu スクリーンショット同期設定ガイド

スクリーンショットを Mac から Ubuntu の `~/Screenshots` に同期する方法を説明します。

---

## 推奨: SynologyDrive を使う方法

SynologyDrive（Synology NAS）を経由して Mac と Ubuntu 間でフォルダを同期する方法です。

### 手順

1. **Mac 側**: スクリーンショットの保存先を SynologyDrive の同期フォルダ内に変更する

   ```
   システム設定 → キーボード → キーボードショートカット → スクリーンショット
   → 「スクリーンショットを保存する場所」を変更
   ```

   または Hazel（後述）を使ってスクリーンショットフォルダを監視し、SynologyDrive にコピーする。

2. **Ubuntu 側**: SynologyDrive クライアントで同じフォルダを `~/Screenshots` にマウントまたは同期する

---

## 代替1: rsync + launchd（Mac 側で定期実行）

Mac の `~/Desktop` に保存されるスクリーンショットを定期的に Ubuntu へ rsync する方法。

### Mac 側の設定

`~/Library/LaunchAgents/com.user.screenshot-sync.plist` を作成:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.screenshot-sync</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/rsync</string>
        <string>-a</string>
        <string>--include=*.png</string>
        <string>--include=*.jpg</string>
        <string>--exclude=*</string>
        <string>/Users/YOUR_MAC_USER/Desktop/</string>
        <string>YOUR_UBUNTU_USER@YOUR_UBUNTU_IP:~/Screenshots/</string>
    </array>
    <key>StartInterval</key>
    <integer>30</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

`YOUR_MAC_USER`、`YOUR_UBUNTU_USER`、`YOUR_UBUNTU_IP` を実際の値に変更して:

```bash
launchctl load ~/Library/LaunchAgents/com.user.screenshot-sync.plist
```

SSH 鍵認証を事前に設定しておく必要があります。

---

## 代替2: Hazel（Mac 側の自動化アプリ）

[Hazel](https://www.noodlesoft.com/) を使い、スクリーンショットフォルダを監視して rsync でコピーするルールを設定する方法。

- 新規ファイル追加を検知して即座にコピーできる（rsync より低遅延）
- Hazel は有料アプリです

---

## 代替3: Syncthing（P2P 同期）

[Syncthing](https://syncthing.net/) を Mac と Ubuntu の両方にインストールし、スクリーンショットフォルダを共有フォルダとして設定する。

- オープンソース・無料
- ローカルネットワーク内では高速
- 設定が他の方法より複雑

```bash
# Ubuntu 側インストール例
sudo apt install syncthing
syncthing
# ブラウザで http://localhost:8384 を開いて設定
```

---

## 動作確認

Ubuntu 側で以下のコマンドを実行してスクリーンショットが届いているか確認:

```bash
ls -lt ~/Screenshots | head -5
```

CLI ツール上で `/shot` を実行して画像が解析されれば設定完了です。
