# 品質ゲート（QUALITY_GATES）

（作成日: 2026-01-27 JST）

---

## 1. 狙い

「lint / type / test / build」と同列で、**セキュリティ/脆弱性/性能/a11y** も “デプロイ前に必須実行” する。

---

## 2. 必須ゲート（最小）

| ゲート | 目的 | 失敗時の扱い |
|---|---|---|
| Lint | コード規約 | ブロック |
| Typecheck | 型安全 | ブロック |
| Unit/Integration test | 回帰防止 | ブロック |
| Build | 本番ビルド成立 | ブロック |
| Secret scan（例:gitleaks） | 鍵漏洩防止 | ブロック |
| Dependency vuln scan（例:OSV） | 既知脆弱性検出 | 原則ブロック（例外は期限付きで許可） |

---

## 3. 推奨ゲート（準必須→将来必須）

| ゲート | 目的 | 備考 |
|---|---|---|
| DAST（例:OWASP ZAP Baseline） | 代表的な脆弱性検知 | Local/CI（コンテナ）/Staging に対して実行 |
| Performance（Lighthouse CI） | CWV/UX | 主要URLを計測 |
| Accessibility（Pa11y CI） | WCAGベース | 主要URL or sitemap 対象 |
| E2E Testing（例:Playwright） | 重要フローの疎通 | staging/prod デプロイ前 |
| CSS Bundle Size | render-blocking CSS の肥大化防止 | PERFORMANCE_RULES §3 参照 |

---

## 4. 運用ルール

- 例外（スキップ）は禁止。どうしても必要なら「理由・期限・代替策」を記録する
- staging/prod デプロイ前は必須ゲートを全通過
- 重大インシデントは `docs/runbooks/INCIDENT_CHECKLIST.md` を追加して運用する
- 実装完了後は `RELEASE_CHECKLIST.md` の「ルール適合チェック」を用いて、ソースコードが規約（SEO/Security/Architecture）に沿っているか最終確認する
- **品質証明**: すべてのゲートを通過した後、`docs/requirements/QUALITY_REPORT_TEMPLATE.md` に基づいた品質レポートを作成し、エビデンスとして保存する。
- 品質ゲートのツール実行も `DEV_RULES §5`（コンテナ前提）に準拠すること。`scripts/` 配下のスクリプトにおいても、Node.js / Chrome 等を必要とする処理は `docker compose run` 経由で実行し、ホスト環境への依存を最小限にする。

---

## 5. スクリプトの品質基準

`scripts/` 配下のシェルスクリプトも以下を満たすこと:

- `bash -n`（構文チェック）がパスする
- ホスト依存（例: python3, jq 等）がある場合は冒頭で依存チェックを行い、未インストール時にインストール案内を表示する
- 対応プラットフォーム（macOS / WSL2）の両方で動作する（`ARCHITECTURE_RULES §4` 参照）

---

## 6. 推奨ゲート実装時の注意事項

推奨ゲート（Lighthouse / Pa11y 等）を Docker コンテナ経由で実行する際、以下の既知の問題と推奨構成を参照すること。

### 6.1 Lighthouse

- 初回実行時にエラーレポート同意の対話プロンプトが表示されスクリプトがブロックされる → `--no-enable-error-reporting` フラグを必ず付与する
- Chrome/Chromium が利用できるイメージを選定すること（`node:slim` 系はシステムライブラリ不足）

### 6.2 Pa11y（Docker / ARM 対応）

- `mcr.microsoft.com/playwright` は ARM（Apple Silicon）非対応。Rosetta エラーが発生する
- 推奨構成:
  - イメージ: `node:22-bookworm`（ARM ネイティブ対応）
  - entrypoint で `apt-get install -y chromium` を実行
  - 環境変数 `PUPPETEER_EXECUTABLE_PATH` で Chromium パスを指定
  - `--no-sandbox` を設定（Docker コンテナの root 実行に必須）

### 6.3 ページリストの共通化

- Lighthouse と Pa11y で対象ページリストが乖離しやすい → スクリプト内で変数（例: `PAGES`）として1箇所で定義し、両ツールのループで共通参照する

```bash
PAGES=("/" "/services" "/contact" "/about" "/news" "/privacy" "/terms")

for page in "${PAGES[@]}"; do
  # Lighthouse / Pa11y 共通で使用
done
```

---

## 付録：ツール参照

- gitleaks: https://github.com/gitleaks/gitleaks
- OSV-Scanner: https://github.com/google/osv-scanner
- OWASP ZAP Baseline Action: https://github.com/zaproxy/action-baseline
- Lighthouse CI: https://github.com/GoogleChrome/lighthouse-ci
- pa11y-ci: https://github.com/pa11y/pa11y-ci
- Playwright: https://playwright.dev/

