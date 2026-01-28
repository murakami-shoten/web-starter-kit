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
- Next.js: Security Headers / Custom Headers  
  https://nextjs.org/docs/app/api-reference/next-config-js/headers
- Next.js: Content Security Policy（CSP）ガイド  
  https://nextjs.org/docs/app/building-your-application/configuring/content-security-policy
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
