# 要件定義書の生成ルール（GENERATE_REQUIREMENTS）

（作成日: 2026-01-27 JST）

## 方針
- `docs/requirements/REQUIREMENTS_TEMPLATE.md` はテンプレとして保持し、**編集しない**
- ヒアリング完了後、テンプレを複製してプロジェクト固有の要件定義書を作成する

## 作成場所と命名
- 置き場所: `docs/requirements/projects/<project_slug>/`
- ファイル名: `REQUIREMENTS_<project_slug>.md`
  - `<project_slug>` は **英小文字 + 数字 + `-`** のみ（例: `my-corp-site`）
  - スペース、日本語、記号は避ける（差分・URL・CIとの相性を優先）

## 生成コマンド例（mac/linux）
```bash
PROJECT_SLUG="my-corp-site"
mkdir -p "docs/requirements/projects/${PROJECT_SLUG}"
cp "docs/requirements/REQUIREMENTS_TEMPLATE.md" \
   "docs/requirements/projects/${PROJECT_SLUG}/REQUIREMENTS_${PROJECT_SLUG}.md"
```

## テンプレ保護（任意）
- CIでテンプレの差分を検知し、変更があれば失敗させる
- もしくは CODEOWNERS でテンプレ編集を制限する
