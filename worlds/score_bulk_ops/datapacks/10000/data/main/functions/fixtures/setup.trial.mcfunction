# 各 run の前にレコードを初期状態 (r_j = j) に戻す。
# bulk_add / bulk_sub は値をドリフトさせるので、run 間で条件を揃えるため。
function main:fixtures/records
scoreboard players set k c 1
scoreboard players set m c 0
