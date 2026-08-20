#> main:verify/wildcard_source
#
# `scoreboard players operation <target> <obj> > * <obj>` の source 側に
# ワイルドカードを渡したときの実挙動を実機で確認するためのプローブ。
#
# 1.20.4 のコマンドツリー上は source も score_holder[multiple] なので構文は通る。
# ただし実装は単一ホルダーとして解決される (先頭 1 件) 見込みで、
# その場合これは全レコードの max にはならない。
#
# 誤って「たまたま最大値のホルダーが先頭だった」を成功と誤判定しないよう、
# 最大値の置き場所を変えて 2 回試し、両方当たったときだけ成功と報告する。
#
# もしこのプローブが「最大値を返した」と報告したら、agg_max の N 本展開は
# 1 コマンドに置き換えられる (要精査)。

# プローブ 1: 最大値を r0 に置く
function main:fixtures/records
scoreboard players set r0 _ 1000000
scoreboard players set m c -2147483648
scoreboard players operation m c > * _
scoreboard players set ok c 0
execute if score m c matches 1000000 run scoreboard players set ok c 1

# プローブ 2: 最大値を r9999 に置く
function main:fixtures/records
scoreboard players set r9999 _ 1000000
scoreboard players set m c -2147483648
scoreboard players operation m c > * _
execute unless score m c matches 1000000 run scoreboard players set ok c 0

execute if score ok c matches 1 run say [score_bulk_ops] probe: source 側 * は最大値を返した -> agg_max を 1 コマンド化できる可能性あり (要精査)
execute unless score ok c matches 1 run say [score_bulk_ops] probe: source 側 * は最大値を返さなかった -> max 集約は N コマンドの列挙が必要

function main:fixtures/records
