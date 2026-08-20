#> main:bulk_sub
# @benchmark
#
# 全レコードへの一括減算。bulk_add と対になる operation 形。

scoreboard players operation * _ -= k c
