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

---

## 4. 運用ルール

- 例外（スキップ）は禁止。どうしても必要なら「理由・期限・代替策」を記録する
- staging/prod デプロイ前は必須ゲートを全通過
- 重大インシデントは `docs/runbooks/INCIDENT_CHECKLIST.md` を追加して運用する

---

## 付録：ツール参照

- gitleaks: https://github.com/gitleaks/gitleaks
- OSV-Scanner: https://github.com/google/osv-scanner
- OWASP ZAP Baseline Action: https://github.com/zaproxy/action-baseline
- Lighthouse CI: https://github.com/GoogleChrome/lighthouse-ci
- pa11y-ci: https://github.com/pa11y/pa11y-ci
- Playwright: https://playwright.dev/
