#> quad_trie_descent:lower_mod
# @benchmark
#
# 方式 B (lower_mod): div / mod で 2 bit ずつ桁を取り出す素朴な方式。
#
# 【採用した定式化】
#   掘りは上位桁から必要なので、下位から剥がすと順序が逆になる。
#   ここでは「各層で 4^(7-k) による div + mod 4」を採った。
#   すなわち 層 k の桁 d_k = (ID / 4^(7-k)) % 4 をその場で計算する。
#   除数 4^7 .. 4^0 は setup で定数 e0..e7 として置いてある。
#   → 一時変数は t の 1 本だけ。層あたり score 3 本 (= / %)。
#   もう一方の定式化 (8 桁ぶんを先に一時変数へ展開してから上位順に消費)
#   は lower_mod_tmp8 として別に用意した。行数と一時変数の本数の
#   トレードオフはその 2 つを比べること。
#
# 【子の並び順】方式 B は桁 d をそのまま子インデックスにする
#   (append を d 個 → [-4] が index d を指す)。
#   方式 A は符号付き昇順 rank = (d+2)%4 を使うので、
#   同じ ID でも到達する末端は A と B で異なる。掘るコストは比較可能。
#
# 【削れる 2 コマンド】層 0 の `%= f` は ID/4^7 が既に 0..3 なので不要、
#   層 7 の `/= e7` は e7 = 1 なので不要。ここでは層ごとの形を
#   揃えるためにあえて残している (計測時はその 2 本ぶんを差し引いて読む)。
#
# ID を random value で引く部分は方式間の共通オーバヘッドとして関数内に含める
# (random_access:list_mapped_trie と同じ構成にして比較可能性を保つ)。

execute store result score p _ run random value 0..65535

# --- 層 0 (桁 d = (ID / 4^7) % 4) ---
scoreboard players operation t _ = p _
scoreboard players operation t _ /= e0 _
scoreboard players operation t _ %= f _
data remove storage _ c[4]
data remove storage _ c[4]
data remove storage _ c[4]
execute if score t _ matches 1.. run data modify storage _ c append value []
execute if score t _ matches 2.. run data modify storage _ c append value []
execute if score t _ matches 3.. run data modify storage _ c append value []

# --- 層 1 (桁 d = (ID / 4^6) % 4) ---
scoreboard players operation t _ = p _
scoreboard players operation t _ /= e1 _
scoreboard players operation t _ %= f _
data remove storage _ c[-4][4]
data remove storage _ c[-4][4]
data remove storage _ c[-4][4]
execute if score t _ matches 1.. run data modify storage _ c[-4] append value []
execute if score t _ matches 2.. run data modify storage _ c[-4] append value []
execute if score t _ matches 3.. run data modify storage _ c[-4] append value []

# --- 層 2 (桁 d = (ID / 4^5) % 4) ---
scoreboard players operation t _ = p _
scoreboard players operation t _ /= e2 _
scoreboard players operation t _ %= f _
data remove storage _ c[-4][-4][4]
data remove storage _ c[-4][-4][4]
data remove storage _ c[-4][-4][4]
execute if score t _ matches 1.. run data modify storage _ c[-4][-4] append value []
execute if score t _ matches 2.. run data modify storage _ c[-4][-4] append value []
execute if score t _ matches 3.. run data modify storage _ c[-4][-4] append value []

# --- 層 3 (桁 d = (ID / 4^4) % 4) ---
scoreboard players operation t _ = p _
scoreboard players operation t _ /= e3 _
scoreboard players operation t _ %= f _
data remove storage _ c[-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][4]
execute if score t _ matches 1.. run data modify storage _ c[-4][-4][-4] append value []
execute if score t _ matches 2.. run data modify storage _ c[-4][-4][-4] append value []
execute if score t _ matches 3.. run data modify storage _ c[-4][-4][-4] append value []

# --- 層 4 (桁 d = (ID / 4^3) % 4) ---
scoreboard players operation t _ = p _
scoreboard players operation t _ /= e4 _
scoreboard players operation t _ %= f _
data remove storage _ c[-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][4]
execute if score t _ matches 1.. run data modify storage _ c[-4][-4][-4][-4] append value []
execute if score t _ matches 2.. run data modify storage _ c[-4][-4][-4][-4] append value []
execute if score t _ matches 3.. run data modify storage _ c[-4][-4][-4][-4] append value []

# --- 層 5 (桁 d = (ID / 4^2) % 4) ---
scoreboard players operation t _ = p _
scoreboard players operation t _ /= e5 _
scoreboard players operation t _ %= f _
data remove storage _ c[-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][4]
execute if score t _ matches 1.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []
execute if score t _ matches 2.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []
execute if score t _ matches 3.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []

# --- 層 6 (桁 d = (ID / 4^1) % 4) ---
scoreboard players operation t _ = p _
scoreboard players operation t _ /= e6 _
scoreboard players operation t _ %= f _
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
execute if score t _ matches 1.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []
execute if score t _ matches 2.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []
execute if score t _ matches 3.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []

# --- 層 7 (桁 d = (ID / 4^0) % 4) ---
scoreboard players operation t _ = p _
scoreboard players operation t _ /= e7 _
scoreboard players operation t _ %= f _
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
execute if score t _ matches 1.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []
execute if score t _ matches 2.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []
execute if score t _ matches 3.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []

data get storage _ c[-4][-4][-4][-4][-4][-4][-4][-4]
