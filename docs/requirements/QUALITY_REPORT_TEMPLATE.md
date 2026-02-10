# 品質保証レポート (Quality Report)

**プロジェクト名**: <Project Name>
**実施日**: <YYYY-MM-DD>
**実施者**: <Name/Agent>
**対象コミット**: <Git Hash>

---

## 1. 概要 (Executive Summary)

本プロジェクトは、所定の品質ゲート（セキュリティ、パフォーマンス、アクセシビリティ、機能テスト）を通過し、リリース基準を満たしていることを報告します。

- **総合判定**: 合格 / 条件付き合格
- **特記事項**: (あれば記載、なければ「特になし」)

---

## 2. 品質ゲート実施結果 (Quality Gates Results)

### 2.1 必須ゲート (Mandatory Gates)

| 項目 | ツール | 結果 | エビデンス/ログファイルのリンク |
|---|---|---|---|
| Lint & Format | ESLint / Prettier | ✅ Pass | `logs/lint.log` |
| Type Check | TypeScript (`tsc`) | ✅ Pass | `logs/typecheck.log` |
| Unit/Integration Test | Vitest / Jest | ✅ Pass | `logs/test.log` (Coverage: XX%) |
| Build | Next.js Build | ✅ Pass | `logs/build.log` |
| Secret Scan | gitleaks | ✅ Pass | No leaks found |
| Dependency Vulnerability | OSV-Scanner / Audit | ✅ Pass | No high severity issues |

### 2.2 推奨ゲート (Recommended Gates)

| 項目 | ツール | 結果 | スコア/詳細 |
|---|---|---|---|
| E2E Testing | Playwright | ✅ Pass / - | Scenario passed: X/X |
| Performance | Lighthouse CI | ✅ Pass / - | Performance: XX, Accessibility: XX... |
| Accessibility | Pa11y CI | ✅ Pass / - | No critical issues |
| DAST | OWASP ZAP | ✅ Pass / - | No high risk alerts |

---

## 3. セキュリティ詳細 (Security Actions)

- [x] **依存パッケージの脆弱性**: スキャン実施済み、Critical/Highなし。
- [x] **機密情報**: コード内のハードコードなし確認済み。
- [x] **HTTPヘッダー**: 推奨セキュリティヘッダー（CSP, HSTS等）の設定確認済み。
- [x] **入力検証**: フォーム等のユーザー入力に対するバリデーション実装確認済み。

---

## 4. バグ・既知の不具合 (Known Issues)

- (現在把握しているが、リリースに支障がない軽微なバグがあれば記載。なければ「なし」)
- Issue #XX: ...

---

## 5. 堅牢性・運用 (Resilience & Operations)

- **エラーハンドリング**: Global Error Boundary 等の実装確認済み。
- **ログ**: エラーログが出力されることを確認済み。
- **バックアップ**: (該当する場合) データバックアップ方針の確認済み。

---

## 6. 結論 (Conclusion)

上記の結果に基づき、本ソフトウェアは要求される品質基準を満たしていると判断します。

**署名**: ____________________
