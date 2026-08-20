#> quad_trie_descent:verify/loop
#
# storage _ ids の先頭から ID を 1 件ずつ取り出して検証する。

execute store result score id _ run data get storage _ ids[0]
data remove storage _ ids[0]
function quad_trie_descent:verify/one
execute if data storage _ ids[0] run function quad_trie_descent:verify/loop
