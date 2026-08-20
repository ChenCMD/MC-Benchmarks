#> quad_trie_descent:verify
#
# ベンチマーク対象ではない (@benchmark を付けない)。
#
# 使い方:
#   /function quad_trie_descent:verify
#     → 判定結果が say でサーバログ / チャットに出る。
#     → 詳細は /data get storage _ v (関数の外から直接実行すること。
#        関数内の data get はコマンド出力が抑制されて見えないため)
#
# 検証内容:
#   1. 方式 A の層ごとの分岐 (符号付き範囲判定で得た rank) が、
#      div/mod で求めた期待値 (d + 2) % 4 と一致するか。
#   2. ストレージ上を実際に掘った結果、ちょうど深さ 8 に到達するか
#      (深さ 8 のパスが解決でき、深さ 9 のパスが解決できないこと)。

scoreboard players set ng _ 0
data modify storage _ v set value {err:[]}
data modify storage _ ids set value [0,1,3,4,12345,21845,43690,49152,54321,65535]
function quad_trie_descent:verify/loop

execute store result storage _ v.ng int 1 run scoreboard players get ng _
execute if score ng _ matches 0 run say [quad_trie_descent] verify: OK
execute unless score ng _ matches 0 run say [quad_trie_descent] verify: NG / /data get storage _ v
