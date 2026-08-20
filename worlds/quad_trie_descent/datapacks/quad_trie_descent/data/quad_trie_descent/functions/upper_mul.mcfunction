#> quad_trie_descent:upper_mul
# @benchmark
#
# 方式 A (upper_mul): ID を 65536 倍して最上位ビット側に寄せ、
# 符号付き整数としての範囲判定 (execute if score ... matches) で
# 上位 2 bit を 1 発ずつ切り出しながら 8 層を掘る。
#
# random_access:list_mapped_trie (1 bit / 層・16 層の二分木版) の
# 2 bit / 層・8 層への翻案。二分木版が「符号 1 発 (matches ..-1)」で
# 済んでいたところが、四分木では 2 bit ぶんの 3 本の範囲判定になる。
#
# p = ID * 65536 とすると、ID の bit15,bit14 が p の bit31,bit30 に乗る。
# 32 bit 符号付きで見たときの区間は次の 4 つ:
#
#   上位 2bit  桁 d   p の区間 (符号付き)                      昇順の位置 = rank
#   00         0      [0, 1073741823]                          2
#   01         1      [1073741824, 2147483647]                 3
#   10         2      [-2147483648, -1073741825]               0
#   11         3      [-1073741824, -1]                        1
#
# つまり rank = (d + 2) % 4。累積判定にすると 3 本で書ける:
#   matches -1073741824..  → rank >= 1
#   matches 0..            → rank >= 2
#   matches 1073741824..   → rank >= 3
#
# 【子の並び順に注意】この方式が選ぶ子インデックスは rank であって桁 d ではない。
# 子 0,1,2,3 はそれぞれ桁 2,3,0,1 に対応する (符号付き昇順)。
# 木を書く側も同じ規約で書けば全単射なので問題ないが、
# 方式 B (lower_mod) は桁 d をそのまま子インデックスにするため、
# 同じ ID でも到達する末端は方式 A と B で異なる。計測上は等価。
#
# なお「桁 d をそのまま子インデックスにしたい」なら、各層で bit31 を
# 反転させれば符号付き順序と符号なし順序が一致する
# (scoreboard players operation p _ += min _ / min = -2147483648)。
# ただし層あたり 1 コマンド増えるのでここでは採用していない。
#
# 【[-4] を動かす仕掛け】
# ノードは常に子 4 個で始まる。空ノードを r 個 append すると長さが 4+r になり、
# [-4] が指す位置が index r にずれる。よって「rank ぶん append」で子を選べる。
# 次の run のために、そのノードを訪れた直後に index 4 の remove を 3 回打って
# 長さを 4 に戻す (自ノードのゴミは自ノードを訪れたときだけ消えればよい)。
# → 層あたり data コマンド 6 本 (remove x3 + 条件付き append x3)。
#   二分木版は層あたり 2 本 x 16 層 = 32 本、四分木版は 6 本 x 8 層 = 48 本。
#   逆にスコア演算は 16 本 → 8 本に減る。ここが本ベンチの見どころ。
#
# 【失敗する remove のコストも含まれる】
# remove は無条件に 3 回打つので、ゴミが 0〜2 個しか無いノードでは
# 残りが「該当要素なし」で失敗する。失敗コマンドのコストも計測に入る。
# 二分木版 (list_mapped_trie) も同じ性質なので方式間の比較には影響しないが、
# 絶対値を「掘り 1 回のコスト」として語るときは注意すること。
#
# ID を random value で引く部分は方式間の共通オーバヘッドとして関数内に含める
# (random_access:list_mapped_trie と同じ構成にして比較可能性を保つ)。
#
# 【机上トレース】(rank = 選んだ子 index, d = 上位から数えた 2bit 桁)
#   ID=49152 (1100000000000000)
#     層0: p= -1073741824 d=3 rank=1
#     層1: p=           0 d=0 rank=2
#     層2: p=           0 d=0 rank=2
#     層3: p=           0 d=0 rank=2
#     層4: p=           0 d=0 rank=2
#     層5: p=           0 d=0 rank=2
#     層6: p=           0 d=0 rank=2
#     層7: p=           0 d=0 rank=2
#   ID=65535 (1111111111111111)
#     層0: p=      -65536 d=3 rank=1
#     層1: p=     -262144 d=3 rank=1
#     層2: p=    -1048576 d=3 rank=1
#     層3: p=    -4194304 d=3 rank=1
#     層4: p=   -16777216 d=3 rank=1
#     層5: p=   -67108864 d=3 rank=1
#     層6: p=  -268435456 d=3 rank=1
#     層7: p= -1073741824 d=3 rank=1
#   ID=12345 (0011000000111001)
#     層0: p=   809041920 d=0 rank=2
#     層1: p= -1058799616 d=3 rank=1
#     層2: p=    59768832 d=0 rank=2
#     層3: p=   239075328 d=0 rank=2
#     層4: p=   956301312 d=0 rank=2
#     層5: p=  -469762048 d=3 rank=1
#     層6: p= -1879048192 d=2 rank=0
#     層7: p=  1073741824 d=1 rank=3

execute store result score p _ run random value 0..65535

# --- 層 0 (ID の bit15,bit14) ---
scoreboard players operation p _ *= q _
data remove storage _ c[4]
data remove storage _ c[4]
data remove storage _ c[4]
execute if score p _ matches -1073741824.. run data modify storage _ c append value []
execute if score p _ matches 0.. run data modify storage _ c append value []
execute if score p _ matches 1073741824.. run data modify storage _ c append value []

# --- 層 1 (ID の bit13,bit12) ---
scoreboard players operation p _ *= f _
data remove storage _ c[-4][4]
data remove storage _ c[-4][4]
data remove storage _ c[-4][4]
execute if score p _ matches -1073741824.. run data modify storage _ c[-4] append value []
execute if score p _ matches 0.. run data modify storage _ c[-4] append value []
execute if score p _ matches 1073741824.. run data modify storage _ c[-4] append value []

# --- 層 2 (ID の bit11,bit10) ---
scoreboard players operation p _ *= f _
data remove storage _ c[-4][-4][4]
data remove storage _ c[-4][-4][4]
data remove storage _ c[-4][-4][4]
execute if score p _ matches -1073741824.. run data modify storage _ c[-4][-4] append value []
execute if score p _ matches 0.. run data modify storage _ c[-4][-4] append value []
execute if score p _ matches 1073741824.. run data modify storage _ c[-4][-4] append value []

# --- 層 3 (ID の bit9,bit8) ---
scoreboard players operation p _ *= f _
data remove storage _ c[-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][4]
execute if score p _ matches -1073741824.. run data modify storage _ c[-4][-4][-4] append value []
execute if score p _ matches 0.. run data modify storage _ c[-4][-4][-4] append value []
execute if score p _ matches 1073741824.. run data modify storage _ c[-4][-4][-4] append value []

# --- 層 4 (ID の bit7,bit6) ---
scoreboard players operation p _ *= f _
data remove storage _ c[-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][4]
execute if score p _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4] append value []
execute if score p _ matches 0.. run data modify storage _ c[-4][-4][-4][-4] append value []
execute if score p _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4] append value []

# --- 層 5 (ID の bit5,bit4) ---
scoreboard players operation p _ *= f _
data remove storage _ c[-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][4]
execute if score p _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []
execute if score p _ matches 0.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []
execute if score p _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4] append value []

# --- 層 6 (ID の bit3,bit2) ---
scoreboard players operation p _ *= f _
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][4]
execute if score p _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []
execute if score p _ matches 0.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []
execute if score p _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4] append value []

# --- 層 7 (ID の bit1,bit0) ---
scoreboard players operation p _ *= f _
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
data remove storage _ c[-4][-4][-4][-4][-4][-4][-4][4]
execute if score p _ matches -1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []
execute if score p _ matches 0.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []
execute if score p _ matches 1073741824.. run data modify storage _ c[-4][-4][-4][-4][-4][-4][-4] append value []

data get storage _ c[-4][-4][-4][-4][-4][-4][-4][-4]
