#> main:bulk_add_each
# @benchmark
#
# 一括加算をワイルドカードでなく N 本のコマンドに展開した版。
# bulk_add / bulk_add_const と比べることで、
# 「`*` 1 本」と「N 本のコマンド」のレコードあたり単価の差が出る。
# この差が agg_max (max 集約はワイルドカードで書けないので必ず N 本になる)
# のコストを読むときの物差しになる。
#
# agg_max と条件を揃えるため、本体は internal/add_all に置いて
# function 呼び出し 1 本ぶんのオーバヘッドを同じだけ含めてある。

function main:internal/add_all
