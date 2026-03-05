# ヒアリングシート（HEARING_SHEET）

このシートは **要件定義の入力フォーム** です。未記入がある場合、AIエージェントはユーザーへ質問して埋めます（推測で埋めない）。

- 本シートは **機能要件**（実装に直接関わるもの）と **非機能要件**（運用・パフォーマンス等。リリース前後に決めてもよいもの）に分けて記載します。
- しつこい再質問を避けるため、ユーザーが「未定/TBD」と回答したらそのままTBDと記載し、決定期限がわかれば併記します。
- 機能要件はおおむね **0〜5章**、非機能要件は **6〜10章** を想定しています。
- TBDの表記ルール: 「まだ未質問」は `TBD（未質問）`、ユーザーに聞いて保留になったら `TBD（確認済/理由/期限）` とメモする（再質問防止のため）

- 目的: コーポレートサイト構築に必要な要件を漏れなく確定する
- 出力: `docs/requirements/projects/<project_slug>/REQUIREMENTS_<project_slug>.md`（テンプレ `REQUIREMENTS_TEMPLATE.md` を複製して作成）

（作成日: 2026-01-27 JST）

---

## 記入ルール

- 分からない項目は `TBD` と書く（空欄禁止）
- **AIエージェントは、要件定義フェーズに限り質問を「一問一答」形式で行う（一度に大量の質問を列挙しない）。合意済み事項は以後繰り返し質問しない。**
- 重要度は `Must / Should / Could / Won't` のいずれか
- “国際標準 / Google推奨 / 定石”がある場合はそれを優先する
- APIキー・トークン等の秘密はシートに直接記載しない。取得状況と保管場所のみ記入し、実キーはローカルの `.env.tmp`（Git管理外）に記録する。未取得はTBDのまま残し、実装開始前に再確認する。

---

## 0. プロジェクト種別

ここでの選択によって、以降の提案内容（サイト構成など）を調整してください。

| 質問 | 回答 | 重要度 |
|---|---|---|
| サイト種別（コーポレート / LP / EC / メディア / Webアプリ / その他） | TBD | Must |
| （その他の場合）具体的な種別 | TBD | Should |

---

## 1. 目的・ゴール

| 質問 | 回答 | 重要度 |
|---|---|---|
| サイトの主目的（KPI） | TBD | Must |
| 主要ターゲット（顧客像） | TBD | Must |
| 提供サービス/強み（USP） | TBD | Must |
| コンバージョン（問い合わせ/見積/採用など） | TBD | Must |

---

## 2. サイト構成（サイトマップ）

**※選択した「プロジェクト種別」に応じて、AIエージェントが適切な構成案を提示すること。**


| ページ | 目的 | 必須要素 | 重要度 |
|---|---|---|---|
| トップ | TBD | TBD | Must |
| サービス | TBD | TBD | Must |
| 実績/事例 | TBD | TBD | Should |
| 会社/プロフィール | TBD | TBD | Must |
| ブログ/記事 | TBD | TBD | Could |
| お問い合わせ | TBD | TBD | Must |
| プライバシーポリシー | TBD | TBD | Must |
| 免責/特商法（必要なら） | TBD | TBD | Could |
| イントロアニメーション / 初回訪問演出 | TBD | TBD | Could |

---

## 3. コンテンツ要件

| 質問 | 回答 | 重要度 |
|---|---|---|
| 必要なコンテンツ種類（文章/画像/動画/資料DL） | TBD | Must |
| 実績の掲載方針（守秘の扱い） | TBD | Should |
| 更新頻度（ブログ等） | TBD | Could |
| CMS選定（MicroCMS/Contentful/WordPress API等）※WPは公開APIのみ推奨 | TBD | Should |
| 下書きプレビュー機能の必要性（ヘッドレスCMS時は実装コスト増） | TBD | Should |
| 著者情報/監修の扱い（E-E-A-T） | TBD | Should |
| お問い合わせ送信データの保存方法（保存しない/DB/SaaS/CMS/その他） | TBD | Must |
| 保存先の候補（DB: Neon/Supabase 等、CMS: Storyblok/Contentful/microCMS 等） | TBD | Should |
| 保存に必要なキー/認証情報は準備できるか（用意できれば `.env.tmp` に記録） | TBD | Should |

---

## 4. デザイン要件

| 質問 | 回答 | 重要度 |
|---|---|---|
| トーン&マナー（例：信頼/ミニマル/ポップ） | TBD | Must |
| ブランド要素（色/フォント/ロゴ） | TBD | Should |
| 参考サイトURL（3〜5件） | TBD | Should |
| 写真素材（自前/フリー/生成AI） | TBD | Should |

---

## 5. SEO要件（技術+運用）

| 質問 | 回答 | 重要度 | 決定タイミング |
|---|---|---|---|
| 主要キーワード/テーマ | TBD | Should | 要件定義時 |
| **サイトタイトル（title）**<br>※未定の場合は「リリースまでのTODO（リリース準備SOW）」とする | TBD<br>（30文字前後推奨） | Must | リリース前 |
| **サイト説明文（description）**<br>※未定の場合は「リリースまでのTODO（リリース準備SOW）」とする | TBD<br>（PC120文字/スマホ50文字程度推奨） | Must | リリース前 |
| **ファビコン / Apple Touch Icon**<br>※画像素材の手配状況<br>※未定の場合は「リリースまでのTODO（リリース準備SOW）」とする | TBD | Must | リリース前 |
| **OGP画像**<br>※SNSシェア用画像の手配状況<br>※未定の場合は「リリースまでのTODO（リリース準備SOW）」とする | TBD | Should | リリース前 |
| 記事運用（MDX前提で良いか） | TBD | Could | 要件定義時 |
| 構造化データ（Organization等） | TBD | Should | 実装前 |
| Search Console / GA4 導入 | TBD | Should | 実装前 |
| GTM（Google Tag Manager）の利用 ※GA4はGTM経由を推奨 | TBD | Must | 実装前 |
| Consent Mode v2 の初期値方針（denied / granted）※§6 クッキー同意と連動 | TBD | Must | 実装前 |
| LLMO（LLM最適化）の要否（`llms.txt` 配置等）※詳細は `LLMO_RULES.md` 参照 | TBD | Could | リリース前 |

※メタ情報（title/description等）は、原則として環境変数（`.env` 等）で管理し、コードへのハードコードは避ける方針とします。
※Search Console / GA4 はコーポレートサイトでは Must 推奨。プロジェクト種別に応じて重要度を調整すること。

---

## 6. セキュリティ要件

| 質問 | 回答 | 重要度 |
|---|---|---|
| セキュリティヘッダー/CSP の厳格度 | TBD | Must |
| フォームのスパム対策（reCAPTCHA等） | TBD | Could |
| レート制限 | TBD | Should |
| 依存脆弱性/secret検出を必須化 | TBD | Must |
| クッキー同意（CMP/GDPR/改正電気通信事業法）の要否 | TBD | Should |

---

## 7. アクセシビリティ

| 質問 | 回答 | 重要度 |
|---|---|---|
| 目標（例：WCAG 2.2 AAを目安） | TBD | Should |
| キーボード操作の要件 | TBD | Should |
| 代替テキスト（alt）必須範囲 | TBD | Should |

---

## 8. 運用・デプロイ

| 質問 | 回答 | 重要度 | 決定タイミング |
|---|---|---|---|
| 独自ドメインの取得状況と候補 | TBD | Must | リリース2週間前 |
| www → apex（またはその逆）のリダイレクト方針 | TBD | Should | リリース前 |
| SSL証明書の取得方針（デプロイ先の自動発行 / 手動） | TBD | Should | リリース前 |
| デプロイ先候補（Vercel/Render等）<br>※Render Free PlanはSMTP不可のため、メール送信が必要ならVercel推奨 | TBD | Should | 要件定義時 |
| 環境（dev/staging/prod） | TBD | Must | 要件定義時 |
| ブランチ→環境デプロイ方針 | TBD | Must | 要件定義時 |
| メール送信プロバイダ（SendGrid/AWS SES/Gmail等） | TBD | Should | 実装前 |
| ログ閲覧方法（管理画面/外部） | TBD | Must | 実装前 |
| サービス監視を行うか（行う場合のツール/範囲/アラート方針） | TBD | Should | 実装前 |
| ステージング環境のアクセス制限方針（Basic認証推奨） | TBD | Should | 実装前 |

※ドメインはDNS伝播に時間がかかるため、早期に確認すること。wwwリダイレクト方針はSEO（canonical URL）に影響する。
※ステージング保護について: デプロイ先の保護機能（例: Vercel Deployment Protection）は仕様が不透明な場合があるため、アプリ側でのBasic認証との併用または代替を検討すること。

---

## 9. 非機能要件

| 質問 | 回答 | 重要度 | 決定タイミング |
|---|---|---|---|
| パフォーマンス目標（CWV） | TBD | Should | 要件定義時 |
| CDN利用の意向（利用/不要/TBD）と前提（無料希望/有料可、静的のみ/HTML含む） | TBD | Should | 実装前 |
| CDN決定の期限（例: リリース前 / リリース後○週以内 / TBD） | TBD | Could | 実装前 |
| 可用性（ダウン許容） | TBD | Could | 要件定義時 |
| バックアップ/復旧方針（CMS/外部サービス上のデータ含む） | TBD | Should | 実装前 |
| ソースコードのバックアップ運用（GitHub障害対策） | TBD | Should | 実装前 |
| 監視（必要度） | TBD | Could | リリース前 |
| E2Eテスト（重要導線の自動化）の要否 | TBD | Should | 実装前 |
| バックアップを行わない場合のリスク認識と合意 | TBD | Must | 要件定義時 |
| バックアップ/監視を行う場合のコスト・体制の合意 | TBD | Must | 実装前 |
| 無料/OSSベースでの監視・バックアップ案（例: OSSエージェント + GitHub/クラウドへのスナップショット）を採用してよいか | TBD | Should | 実装前 |

※ Core Web Vitals の Google 公式閾値（参照: [web.dev/articles/vitals](https://web.dev/articles/vitals)）:

| 指標 | Good | Needs Improvement | Poor |
|---|---|---|---|
| **LCP**（読み込み速度） | ≤ 2.5秒 | 2.5〜4.0秒 | > 4.0秒 |
| **INP**（操作応答性） | ≤ 200ms | 200〜500ms | > 500ms |
| **CLS**（視覚安定性） | ≤ 0.1 | 0.1〜0.25 | > 0.25 |

※ 上記は75パーセンタイルで評価。推奨目標は CWV 3指標 Good 圏内。Lighthouse スコアは参考値として扱う。詳細な評価基準は `PERFORMANCE_RULES.md` を参照。


---

## 10. CI/CD・開発フロー自動化

| 質問 | 回答 | 重要度 | 決定タイミング |
|---|---|---|---|
| 品質ゲートの実行環境（A: ローカルのみ / B: ローカル+CI / C: CIのみ） | TBD | Must | 実装前 |
| Git hooks（pre-commit lint / commit-msg 検証）を導入するか | TBD | Should | 実装前 |
| CI/CD（GitHub Actions 等）を導入するか（導入する場合のサービス名） | TBD | Should | 実装前 |
| 依存更新の自動化（Renovate / Dependabot）を導入するか | TBD | Should | 実装前 |
| 自動リリース（CHANGELOG 自動生成等）の要否 | TBD | Could | 実装前 |
| GitHub コミュニティスタンダード準拠の要否（チーム開発・OSS公開の場合に推奨） | TBD | Should | 実装前 |

※品質ゲート実行環境の詳細は `QUALITY_GATES.md` を参照。Git hooks / CI の推奨構成は `DEV_RULES.md` §3 を参照。
※コミュニティスタンダード準拠時は `CONTRIBUTING.md`、Issue/PRテンプレート、`CODE_OF_CONDUCT.md`、`LICENSE` 等を整備する。

---

## 11. フロント検証環境（実ブラウザ確認）

| 質問 | 回答 | 重要度 |
|---|---|---|
| ホストに Chrome + chrome-devtools-mcp を導入済みか | TBD | Must |
| 未導入ならセットアップしてよいか（バージョン変動の影響を避ける手順で案内） | TBD | Must |
| 実ブラウザ確認を行わない場合の代替手段（Playwrightスクショのみ等） | TBD | Should |

---

## 12. 受入基準（Doneの定義）

| 項目 | 基準 | 重要度 |
|---|---|---|
| 品質ゲート | QUALITY_GATES必須項目が全通過 | Must |
| SEO | sitemap/robots/メタが整備 | Must |
| セキュリティ | CSP/ヘッダーが有効 | Must |
| a11y | 重大違反が無い（目標に応じて） | Should |
| デプロイ後確認 | 全主要ページが200を返す / OGP表示確認 / フォーム送受信確認 | Must |
| GTM/GA4 | イベント受信確認（page_view等） | Should |
| CMP/Cookie同意 | 同意/拒否/設定の各パターン動作確認 | Should |
