#> quad_trie_descent:lower_mod_tmp8
# @benchmark
#
# 方式 B の別定式化。
#
# 【採用した定式化】
#   下位桁から %4 と /4 で 8 桁ぶんを一時変数 u7..u0 に先に展開し、
#   そのあと上位桁 u0 から順に消費して掘る。
#   (u_k = 層 k で使う桁。最初に取れるのは最下位桁なので u7 から埋まる)
#   → 一時変数 8 本 + p、定数は f (=4) の 1 本だけで済む。
#   lower_mod は定数 8 本 + 一時変数 1 本。どちらもスコア演算の本数は
#   ほぼ同じ (22 本 vs 24 本) なので、差が出るならスコアボードの
#   ホルダー数 / ハッシュ衝突側の効果ということになる。
#
# 最上位桁 u0 は展開後の p が既に 0..3 なので %= f を省いている。
#
# ID を random value で引く部分は方式間の共通オーバヘッドとして関数内に含める
# (random_access:list_mapped_trie と同じ構成にして比較可能性を保つ)。

execute store result score p _ run random value 0..65535

# --- 下位桁から 8 桁ぶんを展開する ---
scoreboard players operation u7 _ = p _
scoreboard players operation u7 _ %= f _
scoreboard players operation p _ /= f _
scoreboard players operation u6 _ = p _
scoreboard players operation u6 _ %= f _
scoreboard players operation p _ /= f _
scoreboard players operation u5 _ = p _
scoreboard players operation u5 _ %= f _
scoreboard players operation p _ /= f _
scoreboard players operation u4 _ = p _
scoreboard players operation u4 _ %= f _
scoreboard players operation p _ /= f _
scoreboard players operation u3 _ = p _
scoreboard players operation u3 _ %= f _
scoreboard players operation p _ /= f _
scoreboard players operation u2 _ = p _
scoreboard players operation u2 _ %= f _
scoreboard players operation p _ /= f _
scoreboard players operation u1 _ = p _
scoreboard players operation u1 _ %= f _
scoreboard players operation p _ /= f _
scoreboard players operation u0 _ = p _
# 最上位桁は既に 0..3 なので %= f は不要

# --- 層 0 (桁 u0) ---
data remove storage _ c[4]
data remove storage _ c[4]
data remove storage _ c[4]
execute if score u0 _ matches 1.. run data modify storage _ c append value []
execute if score u0 _ matches 2.. run data modify storage _ c append value []
execute if score u0 _ matches 3.. run data modify storage _ c append value []

# --- 層 1 (桁 u1) ---
data remove storage _ c[-4][4]
data remove storage _ c[-4][4]
data remove storage _ c[-4][4]
execute if score u1 _ matches 1.. run data modify storage _ c[-4] append value []
execute if score u1 _ matches 2.. run data modify storage _ c[-4] append value []
execute if score u1 _ matches 3.. run data modify storage _ c[-4] append value []

# --- 層 2 (桁 u2) ---
data remove storage _ c[-4][-4][4]
data remove storage _ c[-4][-4][4]
data remove storage _ c[-4][-4][4]
execute if score u2 _ matches 1.. run data modify storage _ c[-4][-4] append value []
execute if score u2 _ matches 2.. run data modify storage _ c[-4][-4] append value []
execute if score u2 _ matches 3.. run data modify storage _ c[-4][-4] append value []

# --- 層 3 (桁 u3) ---
data remove storage _ c[-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][4]
execute if score u3 _ matches 1.. run data modify storage _ c[-4][-4][-4] append value []
execute if score u3 _ matches 2.. run data modify storage _ c[-4][-4][-4] append value []
execute if score u3 _ matches 3.. run data modify storage _ c[-4][-4][-4] append value []

# --- 層 4 (桁 u4) ---
data remove storage _ c[-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][4]
execute if score u4 _ matches 1.. run data modify storage _ c[-4][-4][-4][-4] append value []
execute if score u4 _ matches 2.. run data modify storage _ c[-4][-4][-4][-4] append value []
execute if score u4 _ matches 3.. run data modify storage _ c[-4][-4][-4][-4] append value []

# --- 層 5 (桁 u5) ---
data remove storage _ c[-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][4]
execute if score u5 _ matches 1.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []
execute if score u5 _ matches 2.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []
execute if score u5 _ matches 3.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []

# --- 層 6 (桁 u6) ---
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
execute if score u6 _ matches 1.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []
execute if score u6 _ matches 2.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []
execute if score u6 _ matches 3.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []

# --- 層 7 (桁 u7) ---
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
execute if score u7 _ matches 1.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []
execute if score u7 _ matches 2.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []
execute if score u7 _ matches 3.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []

data get storage _ c[-4][-4][-4][-4][-4][-4][-4][-4]
