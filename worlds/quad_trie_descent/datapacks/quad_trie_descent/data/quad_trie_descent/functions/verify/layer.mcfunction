#> quad_trie_descent:verify/layer
#
# 層 ly (0..7) について、方式 A の rank と期待値を突き合わせる。
# s = ID を 65536 倍して ly 層ぶん 4 倍したもの。

# 方式 A: 符号付き範囲の累積判定で rank を出す
scoreboard players set r _ 0
execute if score s _ matches -1073741824.. run scoreboard players add r _ 1
execute if score s _ matches 0.. run scoreboard players add r _ 1
execute if score s _ matches 1073741824.. run scoreboard players add r _ 1

# 期待値: d = (ID / 4^(7-ly)) % 4 → 期待 rank = (d + 2) % 4
scoreboard players operation d _ = id _
execute if score ly _ matches 0 run scoreboard players operation d _ /= e0 _
execute if score ly _ matches 1 run scoreboard players operation d _ /= e1 _
execute if score ly _ matches 2 run scoreboard players operation d _ /= e2 _
execute if score ly _ matches 3 run scoreboard players operation d _ /= e3 _
execute if score ly _ matches 4 run scoreboard players operation d _ /= e4 _
execute if score ly _ matches 5 run scoreboard players operation d _ /= e5 _
execute if score ly _ matches 6 run scoreboard players operation d _ /= e6 _
execute if score ly _ matches 7 run scoreboard players operation d _ /= e7 _
scoreboard players operation d _ %= f _
scoreboard players add d _ 2
scoreboard players operation d _ %= f _

execute unless score r _ = d _ run scoreboard players add ng _ 1
execute unless score r _ = d _ run function quad_trie_descent:verify/report

scoreboard players operation s _ *= f _
scoreboard players add ly _ 1
execute if score ly _ matches ..7 run function quad_trie_descent:verify/layer
