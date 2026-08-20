#> nested_path_access:depth_2w
# @benchmark
#
# ネスト深さ 2 のストレージ書き込み。`[-4]` を 2 回たどって data modify set value する。
#
# 書き込み先は深さ 2 専用の木 w2 の末端。n の内部ノードを set value で
# 上書きするとその下の部分木が壊れるため、深さごとに別の木を用意している。
#
# 値は [0] と [] を交互に書いて元の状態に戻す (list_index_access と同じ形)。
# 同じ値を続けて書かないので「変化なし」判定に当たらない。
# 1 関数につき 4 コマンド (= 2 往復)。

data modify storage _ w2[-4][-4] set value [0]
data modify storage _ w2[-4][-4] set value []
data modify storage _ w2[-4][-4] set value [0]
data modify storage _ w2[-4][-4] set value []
