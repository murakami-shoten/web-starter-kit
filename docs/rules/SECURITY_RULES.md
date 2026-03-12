# セキュリティ規約（SECURITY_RULES）

（作成日: 2026-01-27 JST）

---

## 1. 基準（国際標準/定石）

- OWASP ASVS を“チェックリストの物差し”として使う（少なくとも L1 相当を狙う）
- CSP / セキュリティヘッダーをベース標準として組み込む
- CI相当で「依存脆弱性」「シークレット漏洩」「DAST（コンテナ）」を必須化する（QUALITY_GATES参照）

---

## 2. セキュリティヘッダー（必須）

最低限、以下を標準化（値は要件に応じて調整）:
- Content-Security-Policy（CSP）
- Strict-Transport-Security（HSTS）
- X-Content-Type-Options
- Referrer-Policy
- Permissions-Policy
- (必要に応じて) Cross-Origin-* 系

### 2.1 Next.js 固有の必須設定

- `next.config.mjs` に **`poweredByHeader: false`** を設定する（必須）
  - Next.js はデフォルトで `X-Powered-By: Next.js` レスポンスヘッダーを付与し、フレームワーク情報が露出する
  - OWASP Secure Headers Project で `X-Powered-By` の削除が推奨されている
  - Next.js 公式ドキュメントでも推奨設定として記載

```js
// next.config.mjs
const nextConfig = {
  poweredByHeader: false,  // セキュリティ: X-Powered-By ヘッダーを無効化
  // ...
};
```

> **注意**: 技術スタックの隠蔽だけをセキュリティ対策としないこと。Wappalyzer 等のツールは JS バンドルや HTML 構造からも技術スタックを検出可能。本質的な対策（依存性更新、脆弱性スキャン、CSP 等）を優先する。

### 2.2 UI文言での外部サービス名・技術スタック名の露出禁止

`poweredByHeader: false`（§2.1）は HTTP ヘッダーレベルの対策だが、**ユーザー向け UI 文言**にも同様の原則を適用する。外部サービス名や技術スタック名が UI に含まれると、攻撃者にシステム構成（利用 API・外部サービス・インフラ）を推測させる手がかりとなる。

**ルール:**
- ラベル、注記、エラーメッセージ、ツールチップ、i18n メッセージに外部サービス名・技術スタック名を含めない
- ユーザーに見せる文言は機能・役割ベースで記述する

**例外:**
- プライバシーポリシー、利用規約、法的開示が必要なページでの記載

```
❌ Bad: 「bitFlyer の残高が優先されます」
❌ Bad: 「Stripe で決済処理中です」
❌ Bad: 「PostgreSQL への接続に失敗しました」

✅ Good: 「連携済みの残高が優先されます」
✅ Good: 「決済処理中です」
✅ Good: 「データベースへの接続に失敗しました」
```

**根拠:** OWASP の情報漏洩（Information Disclosure）防止原則に基づく。HTTPヘッダー（§2.1）と UI 文言の両面で多層防御（Defense in Depth）を実現する。

---

## 3. CSP（Next.js）

- Next.js のガイドに沿って、nonce等を含む構成を採用する
- `unsafe-inline` を避ける方針を優先（難しい場合は理由と期限を明記）

---

## 4. 入力・フォーム

- 入力検証（型/サイズ/形式）を必須
- CSRFやスパム対策（用途に応じて）を必須
- レート制限（API/フォーム）を設計に含める

---

## 5. 依存関係と秘密情報

- 依存脆弱性スキャンを必須化（例: OSV-Scanner）
-  секрет（鍵/トークン）検出を必須化（例: gitleaks）
- `.env` や秘密鍵はコミット禁止（テンプレのみOK）

---

## 6. DAST（動的診断）

- **コンテナ戦略**: E2E同様、DAST専用コンテナ（ZAP等）を `docker compose` に追加する構成を採用
- CI上でWebサーバーとセットで立ち上げ、診断を実行する。これによりローカル環境でも同様の診断が可能
- staging/preview に対しても同様に「パッシブ中心」のスキャンを回すことを推奨
- 重大アラートをブロック条件にする

---

## 7. セキュリティ変更のDefinition of Done

- 関連するヘッダー/CSPの影響範囲を説明できる
- 既存ページが壊れない（または意図した変更）
- QUALITY_GATES のセキュリティ系チェックを通過

---

## 付録：主要リファレンス（一次情報）

- OWASP ASVS（チェックリストの物差し）  
  https://owasp.org/www-project-application-security-verification-standard/
- OWASP Secure Headers Project  
  https://owasp.org/www-project-secure-headers/
- Next.js: Security Headers / Custom Headers  
  https://nextjs.org/docs/app/api-reference/next-config-js/headers
- Next.js: Content Security Policy（CSP）ガイド  
  https://nextjs.org/docs/app/building-your-application/configuring/content-security-policy
- Next.js: poweredByHeader 設定  
  https://nextjs.org/docs/app/api-reference/config/next-config-js/poweredByHeader
- Secret scan: gitleaks  
  https://github.com/gitleaks/gitleaks
- Dependency vuln scan: OSV-Scanner  
  https://github.com/google/osv-scanner
- DAST（簡易）: OWASP ZAP Baseline（GitHub Action例）  
  https://github.com/zaproxy/action-baseline
- Performance: Lighthouse CI  
  https://github.com/GoogleChrome/lighthouse-ci
- a11y: pa11y-ci  
  https://github.com/pa11y/pa11y-ci
- WCAG 2.2  
  https://www.w3.org/TR/WCAG22/
- OpenTelemetry spec（可観測性の標準）  
  https://github.com/open-telemetry/opentelemetry-specification
