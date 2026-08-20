#> nested_path_access:depth_3
# @benchmark
#
# ネスト深さ 3 のストレージ読み出し。`[-4]` を 3 回たどって data get する。
#
# depth_1 .. depth_8 は同じ木 n に対して深さだけを変えた 1 パラメータ 1 関数
# (list_index_access と同じ形式)。傾きがそのまま「[-4] 1 段ぶんの値段」になる。
#
# 関数呼び出しのオーバヘッドを薄めるため 1 関数につき 4 回実行する。
#
# 注意: d < 8 では部分木 (要素数 4 のリスト) を、d = 8 では末端 (空リスト) を指す。
#       data get がリストに対して返すのは要素数なので、どちらも O(1) で
#       コストは変わらないが、返る値の意味は違う。

data get storage _ n[-4][-4][-4]
data get storage _ n[-4][-4][-4]
data get storage _ n[-4][-4][-4]
data get storage _ n[-4][-4][-4]
