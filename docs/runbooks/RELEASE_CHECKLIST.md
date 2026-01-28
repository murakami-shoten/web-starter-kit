# リリースチェックリスト（RELEASE_CHECKLIST）

（作成日: 2026-01-27 JST）

---

## 1. 事前確認

- 要件（REQUIREMENTS.md）に対して実装範囲が一致している
- セキュリティ要件（SECURITY_RULES）に影響が無い/あるなら説明できる
- SEO要件（SEO_RULES）に影響が無い/あるなら説明できる

---

## 2. 必須ゲート（QUALITY_GATES）

- lint / typecheck / test / build
- secret scan / dependency vuln scan

---

## 3. 推奨ゲート（可能なら）

- Lighthouse CI（主要URL）
- Pa11y CI（主要URL）
- DAST（脆弱性診断）がパスしていること（Container/Staging）

---

## 4. デプロイ後

- 主要ページが 200 を返す
- 主要導線（問い合わせフォームなど）が動く
- sitemap/robots が取得できる
