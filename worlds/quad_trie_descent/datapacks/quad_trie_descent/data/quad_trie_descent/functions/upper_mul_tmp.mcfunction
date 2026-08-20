#> quad_trie_descent:upper_mul_tmp
# @benchmark
#
# 方式 A の変種。upper_mul は p を直接シフトして潰してしまうが、
# 実際のライブラリでは掘り終わったあとに ID 自体を使いたい
# (末端に ID を書く / 突き合わせる) ことが多い。
# そこで ID は p に残したまま、一時変数 t を潰しながら掘る。
# upper_mul との差は先頭の `t = p` 1 コマンドぶんだけ。
# 判定ロジックと子の並び順は upper_mul と完全に同一。
#
# ID を random value で引く部分は方式間の共通オーバヘッドとして関数内に含める
# (random_access:list_mapped_trie と同じ構成にして比較可能性を保つ)。

execute store result score p _ run random value 0..65535

scoreboard players operation t _ = p _

# --- 層 0 ---
scoreboard players operation t _ *= q _
data remove storage _ c[4]
data remove storage _ c[4]
data remove storage _ c[4]
execute if score t _ matches -1073741824.. run data modify storage _ c append value []
execute if score t _ matches 0.. run data modify storage _ c append value []
execute if score t _ matches 1073741824.. run data modify storage _ c append value []

# --- 層 1 ---
scoreboard players operation t _ *= f _
data remove storage _ c[-4][4]
data remove storage _ c[-4][4]
data remove storage _ c[-4][4]
execute if score t _ matches -1073741824.. run data modify storage _ c[-4] append value []
execute if score t _ matches 0.. run data modify storage _ c[-4] append value []
execute if score t _ matches 1073741824.. run data modify storage _ c[-4] append value []

# --- 層 2 ---
scoreboard players operation t _ *= f _
data remove storage _ c[-4][-4][4]
data remove storage _ c[-4][-4][4]
data remove storage _ c[-4][-4][4]
execute if score t _ matches -1073741824.. run data modify storage _ c[-4][-4] append value []
execute if score t _ matches 0.. run data modify storage _ c[-4][-4] append value []
execute if score t _ matches 1073741824.. run data modify storage _ c[-4][-4] append value []

# --- 層 3 ---
scoreboard players operation t _ *= f _
data remove storage _ c[-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][4]
execute if score t _ matches -1073741824.. run data modify storage _ c[-4][-4][-4] append value []
execute if score t _ matches 0.. run data modify storage _ c[-4][-4][-4] append value []
execute if score t _ matches 1073741824.. run data modify storage _ c[-4][-4][-4] append value []

# --- 層 4 ---
scoreboard players operation t _ *= f _
data remove storage _ c[-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][4]
execute if score t _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4] append value []
execute if score t _ matches 0.. run data modify storage _ c[-4][-4][-4][-4] append value []
execute if score t _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4] append value []

# --- 層 5 ---
scoreboard players operation t _ *= f _
data remove storage _ c[-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][4]
execute if score t _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []
execute if score t _ matches 0.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []
execute if score t _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []

# --- 層 6 ---
scoreboard players operation t _ *= f _
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
execute if score t _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []
execute if score t _ matches 0.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []
execute if score t _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []

# --- 層 7 ---
scoreboard players operation t _ *= f _
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
execute if score t _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []
execute if score t _ matches 0.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []
execute if score t _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []

data get storage _ c[-4][-4][-4][-4][-4][-4][-4][-4]
