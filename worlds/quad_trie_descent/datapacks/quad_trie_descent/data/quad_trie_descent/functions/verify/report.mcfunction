#> quad_trie_descent:verify/report
#
# 不一致を storage _ v.err に積む。

say [quad_trie_descent] verify: rank mismatch / /data get storage _ v
data modify storage _ v.err append value {}
execute store result storage _ v.err[-1].id int 1 run scoreboard players get id _
execute store result storage _ v.err[-1].layer int 1 run scoreboard players get ly _
execute store result storage _ v.err[-1].actual int 1 run scoreboard players get r _
execute store result storage _ v.err[-1].expected int 1 run scoreboard players get d _
