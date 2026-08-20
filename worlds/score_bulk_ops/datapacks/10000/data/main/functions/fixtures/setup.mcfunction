# レコードは実エンティティを使わず、フェイクプレイヤー r0..r9999 のスコアで表現する。
#
# オブジェクティブを 2 本に分けている:
#   _ : レコード本体 r0..r9999。一括演算 (`*`) の対象になる側。
#   c : 定数 k / max 集約先 m / 補助カウンタ。
#       `*` は「スコアボードに登録されている全ホルダー」に展開されるので、
#       これらを _ に置くと一括演算で定数や集約結果まで書き換わってしまう。
#       別オブジェクティブに逃がしておけば値が保たれる。
scoreboard objectives add _ dummy
scoreboard objectives add c dummy
scoreboard players reset *

# 定数
scoreboard players set k c 1

# max 集約先。一括演算 (`*` の対象は _ 側) に巻き込まれないよう c に置く。
scoreboard players set m c 0

# レコード r0..r9999 を採番ループで生成する
# (random_access:fixtures/setup_loop 方式のマクロループ)
function main:fixtures/records
