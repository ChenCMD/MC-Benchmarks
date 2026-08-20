execute store result storage _ d int 1 run scoreboard players add i c 1
function main:fixtures/setup_macro with storage _
execute if score i c matches ..9998 run function main:fixtures/setup_loop
