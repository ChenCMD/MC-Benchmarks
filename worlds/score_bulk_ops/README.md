# score_bulk_ops

GC のコア操作「全レコードへの一括演算 + max 集約」のコストを、レコード数 N でスケールさせて測る。

レコードは実エンティティを使わず、フェイクプレイヤー N 体のスコアで表現する。
N = 100 / 1000 / 10000 を `datapacks/100` `datapacks/1000` `datapacks/10000` の
パック変種として振ってある (mch はベンチマーク用データパックを 1 つずつ有効化して回すので、
名前空間が同じでも変種同士は干渉しない)。

## オブジェクティブの分け方

- `_` … レコード本体 (`r0`..`r{N-1}`)。一括演算の対象になる側。
- `c` … 定数 `k`、max 集約先 `m`、ループ / 検証用のカウンタ。

`m` を `c` 側に置いているのは、`gc_core` の最後の一括加算が集約結果まで +1 してしまうのを避けるため。

`*` は「スコアボードに登録されている全ホルダー」に展開されるので、定数を `_` に置くと
一括演算で定数自身が書き換わってしまう。別オブジェクティブに逃がすと値が保たれる。

## 採用したコマンド構文とその理由

対象は 1.20.x 系 (このリポジトリの他シナリオに合わせて `pack_format` は 17)。
1.20.4 のコマンドツリーでの定義は次のとおり:

```
scoreboard players add       <targets:score_holder[multiple]> <objective> <score>
scoreboard players remove    <targets:score_holder[multiple]> <objective> <score>
scoreboard players operation <targets:score_holder[multiple]> <targetObjective>
                             <operation> <source:score_holder[multiple]> <sourceObjective>
```

- **一括加算 / 一括減算 → `*` を targets に置く 1 コマンド。**
  `targets` は複数指定可なので `*` が使える。`*` は「全 *tracked* ホルダー」に展開され、
  コマンド 1 本の中で N 回のループが回る。
  - `bulk_add` / `bulk_sub` … `scoreboard players operation * _ += k c` (source 側にスコアを読む形)
  - `bulk_add_const` / `bulk_sub_const` … `scoreboard players add * _ 1` (即値の形)
  - 2 つを並べたのは、source 側スコアの読み出し 1 回ぶんの値段を分離したいため。

- **max 集約 → N 本のコマンドに展開。**
  `source` 側も構文上は `score_holder[multiple]` だが、実装は単一ホルダーとして解決される
  (先頭 1 件が使われる) ため、`scoreboard players operation m c > * _` は
  「全レコードの max」にはならない。バニラには「全ホルダーの max を 1 ホルダーに畳む」
  単一コマンドが存在しないので、`agg_max` は `m > r0`, `m > r1`, … を N 本並べている。
  - この判断は実機で検証できるように `main:verify/wildcard_source` にプローブを置いた。
    プローブが「最大値を返した」と報告したら 1 コマンド化できるので、そのときは差し替えること。
  - 代替案として (a) レコードを実エンティティにして `execute as @e run ... > @s`、
    (b) マクロ再帰ループ、がある。(a) はエンティティ側のコストが混ざり本シナリオの前提から
    外れる。(b) はマクロ展開が支配的になる。よって N 本展開を採った。

- **`*` に混ざる補助ホルダー。**
  `*` はオブジェクティブに関係なく全登録ホルダーへ展開されるため、レコード N 件に加えて
  `k` / `i` / `m` / `ng` が対象に混ざる。実際の対象は N + 3〜4 件。
  N=100 では数 % の上振れになるので、N 間の傾きを見るときは頭に入れておくこと。

## 計測対象

| 関数 | 内容 | コマンド本数 |
|:--|:--|:--|
| `bulk_add` | `operation * _ += k c` | 1 |
| `bulk_sub` | `operation * _ -= k c` | 1 |
| `bulk_add_const` | `players add * _ 1` | 1 |
| `bulk_sub_const` | `players remove * _ 1` | 1 |
| `bulk_add_each` | 加算を N 本に展開 (`internal/add_all` 呼び出し) | 1 + N |
| `agg_max` | max 集約 (`internal/max_all` 呼び出し) | 2 + N |
| `gc_core` | 一括減算 → max 集約 → 一括加算 | 4 + N |

`agg_max` と `bulk_add_each` はどちらも `function` 呼び出し 1 本ぶんのオーバヘッドを
同じだけ含むようにしてある (直接比較できるようにするため)。

## 検証

`/function main:verify` (`@benchmark` なし)。

1. `agg_max` が本当に全レコードの最大値 (= N-1) を返すか
2. `bulk_sub` → `bulk_add` の往復でレコードが元に戻るか
3. `gc_core` を通してもレコードが保たれるか (集約された max が N-2 になるか)
4. `operation m c > * _` の実挙動プローブ (最大値の置き場所を変えて 2 回試す)

## 結果の読み方

- **`bulk_add` の N 依存** … `*` 1 本のコストが N に比例するか。比例定数が
  「レコード 1 件あたりの一括演算単価」。これが GC の一括演算パートの実測値になる。
- **`bulk_add` vs `bulk_add_each`** … 同じ N 件の加算を「1 コマンド内ループ」でやるか
  「N コマンド」でやるかの差。差の大部分がコマンドディスパッチ 1 回ぶんの固定費なので、
  これが「コマンドを 1 本増やす値段」の目安になる。
- **`agg_max` の N 依存** … max 集約は N コマンドなので、傾きは `bulk_add_each` に近いはず。
  `bulk_add` の傾きとの比が「ワイルドカードにできないことの代償」。
- **`gc_core` ≒ `agg_max` + `bulk_add` + `bulk_sub`** が成り立つか。
  成り立てば「約 3N」の内訳は 1 : N : 1 コマンド (仕事量は N : N : N) で、
  実測時間は max 集約パートがほぼ全部を占める、という話になる。
  成り立たなければスコアボードのキャッシュ効果を疑う。
- **N = 100 → 1000 → 10000 の傾き** … 線形から外れる (10000 で単価が跳ねる) なら
  スコアボードのハッシュマップがキャッシュに載らなくなった点が見えている。
