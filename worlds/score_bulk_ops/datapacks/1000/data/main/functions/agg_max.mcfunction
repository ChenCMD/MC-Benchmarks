#> main:agg_max
# @benchmark
#
# 全レコードの max を 1 レコード (m) に集約する。
#
# 【なぜ N 本に展開しているか】
# `scoreboard players operation <targets> <obj> <op> <source> <sourceObj>` の
# targets 側は score_holder[multiple] で `*` が使えるが、source 側は
# 構文上 score_holder[multiple] でも実装は単一ホルダーとして解決される。
# つまり `scoreboard players operation m c > * _` は「全レコードの max」には
# ならない (先頭 1 件が使われるだけ)。
# ※この挙動は実機で確認できるよう main:verify/wildcard_source にプローブを
#   置いてある。もしプローブが「最大値を返した」と報告したら、ここは
#   1 コマンドに置き換えられる。
#
# 代替案:
#   - レコードを実エンティティにすれば `execute as @e run ... > @s` で書けるが、
#     エンティティ側のコストが混ざるうえ本シナリオの前提 (実エンティティ不要) から外れる。
#   - マクロによる再帰ループでも書けるが、マクロ展開のコストが支配的になる。
# よってここでは素直に N 本へ展開した。

scoreboard players set m c -2147483648
function main:internal/max_all
