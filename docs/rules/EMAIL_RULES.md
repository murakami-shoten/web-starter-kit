# メール送信規約（EMAIL_RULES）

（作成日: 2026-03-18 JST）

---

## 1. スコープ

### 対象
- **トランザクショナルメール**: 問い合わせフォームの自動応答、通知メール、パスワードリセット等の「ユーザーのアクションに応じて送信されるメール」

### 対象外
- **マーケティングメール**（メルマガ、キャンペーン配信等）: 配信停止（unsubscribe）管理、CAN-SPAM/特定電子メール法の対応等が追加で必要となるため、必要時は別途検討する

---

## 2. 送信方式の選定

### 2.1 3パターンの比較

| 方式 | 追加DNS設定 | メリット | デメリット |
|---|---|---|---|
| **① 自ドメインSMTP**<br>`noreply@a.com` を作ってSMTP送信 | ほぼ不要（既存サーバーなら） | 最もシンプル。自然な From。 | メールサーバーの運用・可用性に依存 |
| **② 外部サービス + DNS認証**<br>SendGrid/Resend等で `@a.com` として送信 | **必要**（SPF/DKIM/DMARC） | 高い配信性。大量送信に強い。API型で実装が楽。 | DNS設定権限が必要。月額コストの可能性。 |
| **③ 外部アカウント直接送信**<br>`@gmail.com` 等からそのまま送信 | 不要 | 無料。セットアップが楽。 | 非公式感。配信レート制限あり。独自ドメインを From にできない。 |

### 2.2 意思決定ツリー

```
独自ドメインのメールサーバー/メールアカウントがある？
├─ Yes → ① 自ドメイン SMTP が最もシンプル（推奨）
│         アカウント（例: noreply@a.com）を作成し SMTP 認証で送信
│
└─ No ──→ DNS レコードの設定権限がある？
           ├─ Yes → ② 外部サービス（SendGrid/Resend 等）+ DNS 認証
           │         SPF/DKIM/DMARC を設定し @a.com として送信
           │
           └─ No ──→ ③ 外部アカウントから送信（Gmail 等）
                      UI 上で送信元アドレスを明示し、受信者の混乱を防ぐ
```

> **注意**: ③ を採用する場合でも、DNS 認証なしで独自ドメイン（`@a.com`）を From に設定してはならない（§5.1 参照）。

---

## 3. ドメイン認証（DNS設定）

### 3.1 概要

独自ドメインからの正当な送信を証明するために、以下の3つのDNSレコード設定が必要。

| 認証方式 | 目的 | 設定内容（DNS TXT レコード） |
|---|---|---|
| **SPF** | 「このサーバーが a.com のメールを送ってよい」を宣言 | `v=spf1 include:<送信サーバー> -all` |
| **DKIM** | メール内容の改ざん検知 + 送信者の暗号的証明 | 公開鍵を TXT レコードに登録 |
| **DMARC** | SPF/DKIM の検証結果に基づくポリシー定義 | `v=DMARC1; p=quarantine; rua=mailto:...` |

### 3.2 方式別のDNS設定要否

| 方式 | SPF | DKIM | DMARC | 備考 |
|---|---|---|---|---|
| ① 自ドメインSMTP | 通常設定済み | 推奨（未設定なら追加） | 推奨 | 既存メールサーバーなら追加作業は少ない |
| ② 外部サービス + DNS認証 | **必須** | **必須** | **必須** | 外部サービスの設定ガイドに従う |
| ③ 外部アカウント直接送信 | 不要 | 不要 | 不要 | 独自ドメインを From にしないため |

### 3.3 DNS設定ができない場合

DNS設定権限がない場合、独自ドメインからの送信は断念し、方式③（外部アカウント直接送信）を採用する。このとき:

- UI上で「自動送信メールは `○○@gmail.com` から届きます」等と明示する
- 将来的にDNS権限を取得できれば、方式②への移行を計画する

### 3.4 デプロイ先の制約

- Render の Free Plan は SMTP ポート（25, 465, 587等）をブロックする。SMTP 直接送信が必要な場合は Vercel の利用を推奨する（`ARCHITECTURE_RULES.md §6` 参照）
- 外部サービスの API 経由送信（SendGrid API / Resend API 等）は SMTP ポートを使わないため、Render でも利用可能

---

## 4. 低ロックイン設計（実装パターン）

メール送信プロバイダを差し替え可能にするため、`LOW_LOCKIN_RULES.md` の方針に沿って抽象化レイヤーを設ける。

### 4.1 設計指針

```
アプリケーション層
  └─ sendEmail(to, subject, body, ...)   ← 共通インターフェース
       └─ アダプター（差し替え可能）
            ├─ SmtpAdapter        ... ① 自ドメイン SMTP
            ├─ SendGridAdapter    ... ② 外部サービス
            ├─ ResendAdapter      ... ② 外部サービス
            └─ GmailApiAdapter    ... ③ Gmail API
```

- アプリケーションコードは共通インターフェース（`sendEmail`）のみを呼ぶ
- プロバイダの切り替えは環境変数（`EMAIL_PROVIDER`）で制御する
- アダプターの実装詳細はアプリ側に漏洩させない

### 4.2 環境変数の例

```env
# メール送信設定
EMAIL_PROVIDER=smtp              # smtp | sendgrid | resend | gmail
EMAIL_FROM=noreply@a.com         # 送信元アドレス

# SMTP の場合
SMTP_HOST=mail.a.com
SMTP_PORT=587
SMTP_USER=noreply@a.com
SMTP_PASS=xxxxxxxx
SMTP_SECURE=true                 # STARTTLS

# 外部サービス（API型）の場合
SENDGRID_API_KEY=SG.xxxxxxxx
# or
RESEND_API_KEY=re_xxxxxxxx
```

---

## 5. セキュリティ

### 5.1 送信元アドレスの偽装禁止

- **DNS認証（SPF/DKIM）が設定されていないドメインを From に使用してはならない**
- 未認証ドメインを From に設定すると、受信側で SPF/DKIM/DMARC 検証に失敗し、スパム判定または拒否される
- `SECURITY_RULES.md §2.2` の「外部サービス名の露出禁止」とは異なり、メールの From アドレスは受信者が送信元を判断する必須情報であるため、正確に設定する

### 5.2 認証情報の管理

- SMTP パスワード、API キーはコードにハードコードしない
- 環境変数（`.env` / `.env.local`）で管理し、Git にコミットしない（`SECURITY_RULES.md §5` 参照）
- ヒアリングで受領した場合は `.env.tmp`（Git管理外）に記録する（`AGENTS.md §3` 参照）

### 5.3 フォーム・レート制限

- メール送信を伴うフォームには、入力検証・CSRF対策・スパム対策（reCAPTCHA等）・レート制限を必ず実装する
- 詳細は `SECURITY_RULES.md §4` を参照

---

## 6. 開発・テスト

### 6.1 開発環境でのメール確認

本番のメール送信プロバイダを開発環境で直接利用しない。以下のいずれかの方法で開発時のメール送信を確認する:

| 方法 | 概要 | 推奨度 |
|---|---|---|
| **メールキャプチャツール**<br>（Mailpit / MailHog 等） | ローカルSMTPサーバーとして動作し、送信メールをWebUIで確認可能 | **推奨** |
| **コンソール出力** | メール本文をターミナルに出力する開発専用アダプター | 最低限 |
| **テスト用アカウント** | Mailtrap 等のSaaS型テスト環境 | 任意 |

### 6.2 Docker Compose 統合例（Mailpit）

```yaml
services:
  mailpit:
    image: axllent/mailpit:latest
    ports:
      - "${MAILPIT_SMTP_PORT:-1025}:1025"   # SMTP
      - "${MAILPIT_UI_PORT:-8025}:8025"      # Web UI
    restart: unless-stopped
```

開発時は `SMTP_HOST=mailpit`, `SMTP_PORT=1025` に設定し、`http://localhost:8025` でメール内容を確認する。

### 6.3 ユニットテスト

- メール送信はモック（`vi.mock()` 等）で差し替え、外部依存なしで完結させる（`DEV_RULES.md` の hermetic テスト方針に準拠）
- テスト対象: 送信パラメータ（to/from/subject/body）の構築ロジック、エラーハンドリング

---

## 7. 可観測性

`OBSERVABILITY_RULES.md` の方針に準じ、メール送信に関する以下のログを記録する:

| イベント | ログレベル | 記録内容 |
|---|---|---|
| 送信成功 | info | 宛先（マスク済み）、件名、タイムスタンプ |
| 送信失敗 | error | エラー内容、宛先（マスク済み）、スタックトレース |
| リトライ | warn | リトライ回数、前回エラー内容 |

### リトライ方針

- 一時的なエラー（ネットワーク障害、プロバイダ側の一時障害等）に対しては、最大3回のリトライを推奨
- リトライ間隔は指数バックオフ（例: 1秒→3秒→9秒）
- 恒久的なエラー（認証失敗、無効なアドレス等）はリトライしない

---

## 付録: 主要リファレンス（一次情報）

- Google: Email sender guidelines（2024年2月〜 SPF/DKIM/DMARC 要件強化）
  https://support.google.com/a/answer/81126
- RFC 7208: SPF（Sender Policy Framework）
  https://datatracker.ietf.org/doc/html/rfc7208
- RFC 6376: DKIM（DomainKeys Identified Mail）
  https://datatracker.ietf.org/doc/html/rfc6376
- RFC 7489: DMARC（Domain-based Message Authentication, Reporting, and Conformance）
  https://datatracker.ietf.org/doc/html/rfc7489
- Mailpit（開発用メールキャプチャツール）
  https://github.com/axllent/mailpit
