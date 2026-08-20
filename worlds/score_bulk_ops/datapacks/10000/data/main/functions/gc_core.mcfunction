#> main:gc_core
# @benchmark
#
# 一括減算 → max 集約 → 一括加算 の一式。
# 発表で「約 3N」と主張する処理そのもの。
#
# ただし内訳のコマンド本数は 3N ではない:
#   一括減算  = 1 コマンド (内部で N 回ループ)
#   max 集約 = N コマンド
#   一括加算  = 1 コマンド (内部で N 回ループ)
# 「3N」はあくまで仕事量の話であって、コマンド 1 本あたりの単価が
# まったく違う点をこのベンチで確かめる。
#
# gc_core - agg_max がちょうど一括減算 + 一括加算のコストになる
# (どちらも m の初期化と max_all の function 呼び出しを 1 本ずつ含むため)。

scoreboard players operation * _ -= k c
scoreboard players set m c -2147483648
function main:internal/max_all
scoreboard players operation * _ += k c
