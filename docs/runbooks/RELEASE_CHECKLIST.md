# リリースチェックリスト（RELEASE_CHECKLIST）

（作成日: 2026-01-27 JST）

---

## 1. 事前確認

- 要件（REQUIREMENTS.md）に対して実装範囲が一致している
- セキュリティ要件（SECURITY_RULES）に影響が無い/あるなら説明できる
- SEO要件（SEO_RULES）に影響が無い/あるなら説明できる
- LLMO要件（LLMO_RULES）に影響が無い/あるなら説明できる

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

## 4. ルール適合チェック（Source Code Review）

**実装が規定通りに行われているか、ソースコードレベルで確認すること。**

### 4.1 SEO/メタ情報（SEO_RULES, REQUIREMENTS）
- [ ] `title` / `description` がコードにハードコードされていないこと（環境変数 `NEXT_PUBLIC_SITE_TITLE` 等を使用）
- [ ] `favicon` / `apple-touch-icon` / `OGP画像` が実ファイルとして存在し、正しく参照されていること
- [ ] `sitemap.xml` / `robots.txt` が生成されている（または生成ロジックがある）こと

### 4.1.1 LLMO（LLMO_RULES）
- [ ] `/llms.txt` が設置されていること（`public/llms.txt` または Route Handler による動的生成）
- [ ] `llms.txt` の内容が構造化データ（Organization 等）および SEO メタ情報と整合していること
- [ ] `llms.txt` 内のリンク先が全て 200 を返すこと

### 4.2 セキュリティ/品質（SECURITY_RULES, DEV_RULES）
- [ ] フォームにバリデーション、レート制限、スパム対策（reCAPTCHA等）が入っていること
- [ ] `any` 型が乱用されていないこと（`eslint-disable` が多用されていないこと）
- [ ] 外部API呼び出しのキーがハードコードされていないこと

### 4.3 構成/保守性（DEV_RULES, ARCHITECTURE_RULES）
- [ ] Next.js アプリコードが `frontend/` 配下に収まっていること
- [ ] コンポーネントが役割（ui/domain/features）ごとに整理されていること

---

## 5. デプロイ後

- 主要ページが 200 を返す
- 主要導線（問い合わせフォームなど）が動く
- sitemap/robots が取得できる
- `/llms.txt` が取得できる（200 を返す）

## 6. ドキュメント整備 (Documentation)

- [ ] `docs/requirements/projects/<project_slug>/QUALITY_REPORT.md` が作成され、品質ゲートの結果が記録されていること
- [ ] ルートの `README.md` がプロジェクト固有の内容に書き直され、不要なテンプレート情報が削除されていること
- [ ] 詳細ドキュメントが適切に分割され、リンクで辿れるよう整理されていること

