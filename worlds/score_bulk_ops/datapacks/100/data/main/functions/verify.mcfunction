#> main:verify
#
# ベンチマーク対象ではない (@benchmark を付けない)。
#
# 使い方: /function main:verify
#   → 判定結果が say でサーバログ / チャットに出る。
#
# 検証内容:
#   1. agg_max が本当に全レコードの最大値 (= N-1) を返すか
#   2. bulk_sub → bulk_add の往復でレコードが元に戻るか
#   3. gc_core を通してもレコードが保たれるか
#   4. `operation m c > * _` (source 側ワイルドカード) の実挙動プローブ

function main:fixtures/records
scoreboard players set ng c 0

# 1. agg_max
function main:agg_max
execute unless score m c matches 99 run scoreboard players add ng c 1
execute unless score m c matches 99 run say [score_bulk_ops] verify: NG (agg_max が 99 を返していない)

# 2. bulk_sub -> bulk_add の往復
function main:bulk_sub
function main:bulk_add
execute unless score r0 _ matches 0 run scoreboard players add ng c 1
execute unless score r0 _ matches 0 run say [score_bulk_ops] verify: NG (往復後に r0 が 0 に戻っていない)
execute unless score r99 _ matches 99 run scoreboard players add ng c 1
execute unless score r99 _ matches 99 run say [score_bulk_ops] verify: NG (往復後に r99 が 99 に戻っていない)

# 3. gc_core を通す
function main:gc_core
execute unless score r0 _ matches 0 run scoreboard players add ng c 1
execute unless score r99 _ matches 99 run scoreboard players add ng c 1
execute unless score m c matches 98 run scoreboard players add ng c 1
execute unless score m c matches 98 run say [score_bulk_ops] verify: NG (gc_core 中の max が 98 になっていない)

# 4. ワイルドカード source のプローブ
function main:verify/wildcard_source

function main:fixtures/records
execute if score ng c matches 0 run say [score_bulk_ops] verify: OK
execute unless score ng c matches 0 run say [score_bulk_ops] verify: NG
