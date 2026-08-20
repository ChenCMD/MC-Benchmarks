#> quad_trie_descent:verify/descend
#
# score id の ID について、upper_mul と同じ手順でストレージ上を実際に掘り、
# ちょうど深さ 8 に到達したかを確認する。
# (掘りが浅すぎ / 深すぎになる実装ミスをここで拾う)

scoreboard players operation s _ = id _

# --- 層 0 ---
scoreboard players operation s _ *= q _
data remove storage _ c[4]
data remove storage _ c[4]
data remove storage _ c[4]
execute if score s _ matches -1073741824.. run data modify storage _ c append value []
execute if score s _ matches 0.. run data modify storage _ c append value []
execute if score s _ matches 1073741824.. run data modify storage _ c append value []

# --- 層 1 ---
scoreboard players operation s _ *= f _
data remove storage _ c[-4][4]
data remove storage _ c[-4][4]
data remove storage _ c[-4][4]
execute if score s _ matches -1073741824.. run data modify storage _ c[-4] append value []
execute if score s _ matches 0.. run data modify storage _ c[-4] append value []
execute if score s _ matches 1073741824.. run data modify storage _ c[-4] append value []

# --- 層 2 ---
scoreboard players operation s _ *= f _
data remove storage _ c[-4][-4][4]
data remove storage _ c[-4][-4][4]
data remove storage _ c[-4][-4][4]
execute if score s _ matches -1073741824.. run data modify storage _ c[-4][-4] append value []
execute if score s _ matches 0.. run data modify storage _ c[-4][-4] append value []
execute if score s _ matches 1073741824.. run data modify storage _ c[-4][-4] append value []

# --- 層 3 ---
scoreboard players operation s _ *= f _
data remove storage _ c[-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][4]
execute if score s _ matches -1073741824.. run data modify storage _ c[-4][-4][-4] append value []
execute if score s _ matches 0.. run data modify storage _ c[-4][-4][-4] append value []
execute if score s _ matches 1073741824.. run data modify storage _ c[-4][-4][-4] append value []

# --- 層 4 ---
scoreboard players operation s _ *= f _
data remove storage _ c[-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][4]
execute if score s _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4] append value []
execute if score s _ matches 0.. run data modify storage _ c[-4][-4][-4][-4] append value []
execute if score s _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4] append value []

# --- 層 5 ---
scoreboard players operation s _ *= f _
data remove storage _ c[-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][4]
execute if score s _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []
execute if score s _ matches 0.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []
execute if score s _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []

# --- 層 6 ---
scoreboard players operation s _ *= f _
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
execute if score s _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []
execute if score s _ matches 0.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []
execute if score s _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []

# --- 層 7 ---
scoreboard players operation s _ *= f _
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
execute if score s _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []
execute if score s _ matches 0.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []
execute if score s _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []

# 深さ 8 は解決できなければならない
execute unless data storage _ c[-4][-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute unless data storage _ c[-4][-4][-4][-4][-4][-4][-4][-4] run say [quad_trie_descent] verify: NG (深さ 8 に到達していない)

# 深さ 9 は解決できてはならない (末端は空リストなので [-4] が外れる)
execute if data storage _ c[-4][-4][-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ c[-4][-4][-4][-4][-4][-4][-4][-4][-4] run say [quad_trie_descent] verify: NG (8 層より深く潜れてしまっている)
