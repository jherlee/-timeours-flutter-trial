# TimeOurs 登入頁 Flutter 試跑包

目的：驗證「程式碼推上 GitHub → 雲端 Runner 編出 iOS 模擬器版＋Android APK」這條流程，不碰上架、不接後端。

## 畫面

登入頁（`lib/main.dart`），設計依據 2026-11-06/07 自 timeours.com 實站驗證的規格：

- 置中單欄約 301px；標題「登入 TimeOurs」20px
- OAuth 按鈕：Facebook #334C7E、Google #C93B24、X 黑色
- 輸入框無 label、只有 placeholder；錯誤訊息色 #FF6B7D
- 註冊：帳號／信箱／密碼／確認密碼 4 欄＋條款句
- 驗證：帳號 6–50 字元、密碼 ≥8 字元、兩次密碼一致；登入僅檢查非空
- 預設深藍灰主題：背景 #1C2134、卡片 #262E46、主色 #E64C65（Figma primary）

按下登入／註冊／OAuth 只做格式驗證並提示「試跑版，尚未串接後端」。

## 內容

- `pubspec.yaml`：無第三方套件，Runner 建置不會卡在套件解析
- `lib/main.dart`：登入頁畫面（單檔）
- `.github/workflows/build.yml`：推上 main 就自動跑
  - macOS runner：`flutter build ios --simulator --no-codesign`，產物 `Runner.app`
  - Ubuntu runner：`flutter build apk --debug`，產物 `app-debug.apk`
  - 兩個產物都上傳為 Actions artifacts，可直接下載

## 試跑步驟

1. 在 GitHub 開一個 repo（建議公開 repo：Runner 免費額度較多；私人 repo 每月 2,000 分鐘）
2. 把這四個檔案推上去（`pubspec.yaml`、`lib/main.dart`、`.github/workflows/build.yml`，以及本 README 可留可不留）
3. 到 repo 的 Actions 頁看 build 是否成功
4. 成功後下載 artifacts：
   - iOS：`Runner.app`，在 Mac 上用模擬器開啟（`xcrun simctl install booted Runner.app`）
   - Android：`app-debug.apk`，裝到模擬器或實機測試

## 不在這次試跑範圍內

- 上架 App Store / Google Play（需 Apple Developer Program 會員 US$99/年、發行憑證 .p12、provisioning profile、App Store Connect API key .p8；彼得潘的上架篇尚未發表）
- 真實登入／OAuth 串接
- 其他畫面（訊息頁、時間軸等）：試跑通過後再按 Figma 一頁一頁做

## 參考

- 彼得潘 2026-10-25：〈透過 GitHub 的雲端 Runner，任何裝置都能請 AI 用 Flutter 開發 iOS & Android App〉（Medium；原文曾被 Cloudflare 擋下，步驟請以原文為準）
- Apperdev：〈Publish Flutter App from Windows without Mac〉（全文已讀，補齊上架所需憑證清單）
