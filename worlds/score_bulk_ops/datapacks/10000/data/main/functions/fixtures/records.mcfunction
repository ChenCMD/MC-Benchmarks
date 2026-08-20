# レコード r0..r9999 を r_j = j に初期化する。
# setup からも setup.trial からも verify からも呼ぶので冪等にしてある。
scoreboard players set i c -1
function main:fixtures/setup_loop
data remove storage _ d
