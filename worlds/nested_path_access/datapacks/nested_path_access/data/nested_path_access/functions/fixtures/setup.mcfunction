scoreboard objectives add _ dummy
scoreboard players reset *

# --- 読み出し用: 各層 4 要素・深さ 8 のネスト構造 n ---
# n はリストの入れ子。レベル 0 = n 自身、レベル 8 = 末端。
# n[] set from n を 1 回打つごとに階層が 1 段増える (各要素が丸ごと n になる)。
# 末端まで list 型で統一しているのは NBT の制約のため:
#   NBT のリストは同一型の要素しか持てないので、階層ごとに型が混ざる形は作れない。
data modify storage _ n set value [[],[],[],[]]
data modify storage _ n[] set from storage _ n
data modify storage _ n[] set from storage _ n
data modify storage _ n[] set from storage _ n
data modify storage _ n[] set from storage _ n
data modify storage _ n[] set from storage _ n
data modify storage _ n[] set from storage _ n
data modify storage _ n[] set from storage _ n

# --- 書き込み用: 深さごとの木 w1..w8 ---
# w<d> はレベル 0..d の d+1 段。つまり w<d>[-4] を d 回たどると必ず末端に着く。
# 深さごとに別の木を用意しているのは、n の内部ノードを data modify set value で
# 上書きするとその下の部分木が丸ごと消えてしまうため。
# 末端 (空リスト) を書き換える形にすれば構造を壊さずに済み、
# 読み出し側と同じ「[-4] を d 回たどる」パス解決コストだけを測れる。
data modify storage _ w1 set value [[],[],[],[]]
data modify storage _ w2 set value [[],[],[],[]]
data modify storage _ w2[] set from storage _ w2
data modify storage _ w3 set value [[],[],[],[]]
data modify storage _ w3[] set from storage _ w3
data modify storage _ w3[] set from storage _ w3
data modify storage _ w4 set value [[],[],[],[]]
data modify storage _ w4[] set from storage _ w4
data modify storage _ w4[] set from storage _ w4
data modify storage _ w4[] set from storage _ w4
data modify storage _ w5 set value [[],[],[],[]]
data modify storage _ w5[] set from storage _ w5
data modify storage _ w5[] set from storage _ w5
data modify storage _ w5[] set from storage _ w5
data modify storage _ w5[] set from storage _ w5
data modify storage _ w6 set value [[],[],[],[]]
data modify storage _ w6[] set from storage _ w6
data modify storage _ w6[] set from storage _ w6
data modify storage _ w6[] set from storage _ w6
data modify storage _ w6[] set from storage _ w6
data modify storage _ w6[] set from storage _ w6
data modify storage _ w7 set value [[],[],[],[]]
data modify storage _ w7[] set from storage _ w7
data modify storage _ w7[] set from storage _ w7
data modify storage _ w7[] set from storage _ w7
data modify storage _ w7[] set from storage _ w7
data modify storage _ w7[] set from storage _ w7
data modify storage _ w7[] set from storage _ w7
data modify storage _ w8 set value [[],[],[],[]]
data modify storage _ w8[] set from storage _ w8
data modify storage _ w8[] set from storage _ w8
data modify storage _ w8[] set from storage _ w8
data modify storage _ w8[] set from storage _ w8
data modify storage _ w8[] set from storage _ w8
data modify storage _ w8[] set from storage _ w8
data modify storage _ w8[] set from storage _ w8
