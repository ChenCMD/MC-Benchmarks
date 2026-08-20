#> quad_trie_descent:verify/one
#
# score id に入っている 1 件の ID を検証する。

# 1. 層ごとの分岐の一致を見る
scoreboard players operation s _ = id _
scoreboard players operation s _ *= q _
scoreboard players set ly _ 0
function quad_trie_descent:verify/layer

# 2. 実際にストレージを掘って到達深さを見る
function quad_trie_descent:verify/descend
