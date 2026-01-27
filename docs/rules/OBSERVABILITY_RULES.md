# 可観測性規約（OBSERVABILITY_RULES）

（作成日: 2026-01-27 JST）

---

## 1. 前提

- ローカル: コンソールログ / サーバログ
- staging/prod: デプロイ先サービスの管理画面ログで確認する

---

## 2. ローカルでの“仕組み”の現実解

ローカルは「最低限これだけ」でOK:

- 例外はスタックトレースを必ず出す
- リクエスト単位のログ（path, method, status, duration）を出す
- 開発時は必要に応じて debug レベルを切替可能にする

---

## 3. 低ロックインで強化したくなった場合（将来）

- OpenTelemetry を採用すると、ログ/メトリクス/トレースの出力口を標準化しやすい
- ただし最初から重くしない（必要になってから段階導入）

---

## 付録：主要リファレンス

- OpenTelemetry spec: https://github.com/open-telemetry/opentelemetry-specification
