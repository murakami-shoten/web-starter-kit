# SOW (Statement of Work) テンプレート

このファイルはテンプレートです。各フェーズごとに複製し、`docs/requirements/projects/<project_slug>/SOW_<phase>.md` として保存してください。

---

## 1. 基本情報
- プロジェクト: <project_slug>
- フェーズ: <phase_name>（例: discovery / design / dev / test / launch）
- 期間: TBD
- 関係者: TBD（責任者/レビュアー/承認者）

## 2. 目的とスコープ
- 目的: TBD
- 含まれる範囲: TBD
- 含まれない範囲（Out of scope）: TBD

## 3. 成果物
- TBD（例: IA案、UIモック、実装ブランチ、テストレポート など）
- ワイヤーフレームが必要な場合：ユーザー提供物（Figma等）があればそれを基に実装する。提供が無い場合はAIエージェントがリポジトリ内に静的HTMLモックとして作成・配置する。ユーザーにFigma等での新規作成を要求しない。
- フロントエンド実装・調整フェーズでは、`chrome-devtools-mcp` または Playwright を用いてAIエージェント自身がブラウザ上で動作/レイアウト/コンソールログを確認しながら作業することを成果物・作業手順に含める

## 4. 受入基準（Definition of Done）
- QUALITY_GATES の必須項目を通過（該当する場合）
- フェーズ特有の完了条件を具体的に列挙（例: 主要画面モック3枚承認、E2Eシナリオ5本パス など）

## 5. 前提・依存
- TBD（例: 要件確定、API仕様、ブランドガイドの提供、ワイヤーフレーム/UIモック承認済みなど）
- ※実装フェーズでは、承認済みのワイヤーフレーム/UIモックがあればそれを画面構成の基準として参照すること

## 6. リスクと緩和策
- 項目: リスク内容 / 影響 / 対応方針 / 期限
- TBD

## 7. 変更管理
- スコープ変更時の手続き: TBD（合意フロー、記録場所）

## 8. コミュニケーション/レビュー体制
- 定例/レビュー頻度、チャネル、承認者: TBD

## 9. 参照
- 要件定義書: `docs/requirements/projects/<project_slug>/REQUIREMENTS_<project_slug>.md`
- 関連ドキュメント: TBD
