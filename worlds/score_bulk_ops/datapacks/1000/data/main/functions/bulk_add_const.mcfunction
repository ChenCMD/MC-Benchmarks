#> main:bulk_add_const
# @benchmark
#
# 全レコードへの一括加算を、source 側のスコア参照が無い
# `scoreboard players add <targets> <objective> <score>` で書いた版。
# bulk_add との差が「source 側スコアの読み出し 1 回」ぶんのコストになる。

scoreboard players add * _ 1
