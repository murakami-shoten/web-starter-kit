# パフォーマンス規約（PERFORMANCE_RULES）

（作成日: 2026-02-19 JST）

---

## 1. 大原則

- Core Web Vitals（LCP / CLS / INP）を主要指標とし、ユーザー体感を最優先する
- render-blocking リソース（CSS / JS）を最小限に抑える
- 計測に基づいて改善する（推測で最適化しない）

---

## 2. フォント読み込み

### 2.1 CJK フォント（日本語・中国語・韓国語）は `next/font/google` を使わない

`next/font/google` は Google Fonts API が返す**全 unicode-range サブセット**の `@font-face` 宣言を CSS バンドルに埋め込む。CJK フォントはサブセット数が 100 以上あり、CSS だけで **100KB 超の render-blocking リソース**になる。

> **実測例（Noto Sans JP）:**
> - 改善前: 188KB / 249 @font-face → FCP 4.2s / LCP 5.6s / Performance 63
> - 改善後: ~5KB / 12 @font-face → FCP 2.1s / LCP 3.5s / Performance 81

**ラテン文字フォント（Inter, Manrope 等）ではこの問題は発生しない。** サブセット数が少なく CSS が小さいため、`next/font/google` をそのまま使用して問題ない。

### 2.2 CJK フォントの代替手段

以下のいずれかを使用する:

1. **fontsource + カスタム @font-face CSS**（推奨）
   - `@fontsource-variable/<font>` をインストール
   - 主要サブセット（仮名・頻出漢字・ラテン等）のみ `@font-face` を定義
   - `unicode-range` でブラウザが必要なサブセットだけ非同期ダウンロード
2. **next/font/local** + 手動 woff2 配置
   - woff2 ファイルを `frontend/src/fonts/` に配置
   - `next/font/local` で読み込み、`unicode-range` を手動指定

### 2.3 font-display

- `font-display: swap` を必須とする
- `optional` は LCP 改善に有効な場合があるが、初回訪問でフォントが適用されない可能性があるため、ブランド要件と相談して決定する

---

## 3. CSS バンドルサイズ

- ビルド後の CSS チャンクで **50KB 超**のものがないか確認する
- `@font-face` の数が **20 を超える** CSS チャンクは警告対象とする
- 確認コマンド例:

```bash
# CSS チャンクサイズ確認
wc -c .next/static/chunks/*.css

# @font-face 数の確認
grep -c '@font-face' .next/static/chunks/*.css
```

### CI/品質ゲートへの組み込み（将来）

```bash
# CSS チャンクサイズチェック（50KB 超で失敗）
for f in .next/static/chunks/*.css; do
  size=$(wc -c < "$f")
  if [ "$size" -gt 51200 ]; then
    echo "⚠ CSS chunk too large: $f ($size bytes)"
    exit 1
  fi
done
```

---

## 4. CJK フォント導入時の推奨ディレクトリ構成

```
frontend/src/
├── fonts/                          # woff2 ファイル格納（gitignore しない）
│   ├── noto-sans-jp-*.woff2        # fontsource から必要サブセットのみコピー
│   └── README.md                   # フォント追加手順を記載
├── app/
│   ├── noto-sans-jp.css            # カスタム @font-face（unicode-range 付き）
│   ├── globals.css                 # --font-noto 等の CSS 変数を参照
│   └── layout.tsx                  # import './noto-sans-jp.css'
```

---

## 5. Core Web Vitals 目標と評価基準

### 5.1 Google 公式閾値

各指標はページ読み込みの **75パーセンタイル** で評価される（モバイル・デスクトップ別）。

| 指標 | Good（SEOランキングに好影響） | Needs Improvement | Poor |
|---|---|---|---|
| **LCP**（Largest Contentful Paint） | ≤ 2.5秒 | 2.5〜4.0秒 | > 4.0秒 |
| **INP**（Interaction to Next Paint） | ≤ 200ms | 200〜500ms | > 500ms |
| **CLS**（Cumulative Layout Shift） | ≤ 0.1 | 0.1〜0.25 | > 0.25 |

参照: [web.dev/articles/vitals](https://web.dev/articles/vitals)

### 5.2 推奨目標

- **CWV 3指標すべてが Good 圏内** に入ることを最優先目標とする
- **Lighthouse Performance スコアは参考値** として扱い、スコア自体を目標にしない

### 5.3 フレームワーク制約に関する注意

- モバイルの Lighthouse Performance スコアは CWV の **Lab 計測値** であり、フィールドデータ（CrUX）とは乖離する場合がある
- React / Next.js ランタイム（~220KB）のダウンロード・パースにより、**モバイル Performance 90+ の達成は現実的に困難** な場合がある
- SSG / ISR を積極活用し、Client Component の JavaScript を最小限に抑えることで改善可能
- `dynamic(() => import(...))` による動的インポートで、初期ロードに不要なコンポーネントを遅延読み込みする

---

## 付録：参考リファレンス

- web.dev: Optimize WebFont loading
  https://web.dev/articles/optimize-webfont-loading
- fontsource（Google Fonts の npm パッケージ版）
  https://fontsource.org/
- Next.js Font Optimization
  https://nextjs.org/docs/app/building-your-application/optimizing/fonts
- Google Fonts: Noto Sans JP CSS API（248 @font-face を返す例）
  https://fonts.googleapis.com/css2?family=Noto+Sans+JP
