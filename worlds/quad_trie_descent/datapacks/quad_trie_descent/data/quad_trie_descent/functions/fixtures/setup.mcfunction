scoreboard objectives add _ dummy
scoreboard players reset *

# --- 深さ 8・各層 4 要素の四分木 c を構築する ---
# c はリストの入れ子。レベル 0 = c 自身、レベル 8 = 末端 (空リスト)。
# c[] set from c を 1 回打つごとに階層が 1 段増える (各要素が丸ごと c になる)。
# 末端まで list 型で統一しているのは NBT の制約のため:
#   NBT のリストは同一型の要素しか持てないので、末端を数値にすると
#   最下層ノード (数値のリスト) への空ノード append が型不一致で失敗する。
#   全階層を list にしておけば、どの層への append も必ず通る。
data modify storage _ c set value [[],[],[],[]]
data modify storage _ c[] set from storage _ c
data modify storage _ c[] set from storage _ c
data modify storage _ c[] set from storage _ c
data modify storage _ c[] set from storage _ c
data modify storage _ c[] set from storage _ c
data modify storage _ c[] set from storage _ c
data modify storage _ c[] set from storage _ c

# --- 定数 ---
# q: ID を最上位ビット側へ寄せる倍率 (2^16)
scoreboard players set q _ 65536
# f: 1 層ぶんのシフト / 桁の基数
scoreboard players set f _ 4
# e0..e7: 方式 B (lower_mod) の層ごとの除数 4^(7-k)
scoreboard players set e0 _ 16384
scoreboard players set e1 _ 4096
scoreboard players set e2 _ 1024
scoreboard players set e3 _ 256
scoreboard players set e4 _ 64
scoreboard players set e5 _ 16
scoreboard players set e6 _ 4
scoreboard players set e7 _ 1

# u0..u7 (lower_mod_tmp8 の一時変数) と p / t を先に登録しておく。
# ベンチ 1 発目だけスコア生成コストが乗るのを避けるため。
scoreboard players set p _ 0
scoreboard players set t _ 0
scoreboard players set u0 _ 0
scoreboard players set u1 _ 0
scoreboard players set u2 _ 0
scoreboard players set u3 _ 0
scoreboard players set u4 _ 0
scoreboard players set u5 _ 0
scoreboard players set u6 _ 0
scoreboard players set u7 _ 0
