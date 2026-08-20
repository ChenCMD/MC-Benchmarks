#> nested_path_access:verify
#
# ベンチマーク対象ではない (@benchmark を付けない)。
#
# 使い方: /function nested_path_access:verify
#   → 判定結果が say でサーバログ / チャットに出る。
#
# 検証内容:
#   1. n の各層がちょうど 4 要素であること
#   2. n の深さがちょうど 8 であること (深さ 8 は解決でき、深さ 9 は解決できない)
#   3. w<d> の深さがちょうど d であること
#   4. depth_<d>w を通しても w<d> の構造が壊れないこと

scoreboard players set ng _ 0

# 1. n の各層がちょうど 4 要素か ([3] は在る / [4] は無い)
execute unless data storage _ n[3] run scoreboard players add ng _ 1
execute if data storage _ n[4] run scoreboard players add ng _ 1
execute unless data storage _ n[-4][3] run scoreboard players add ng _ 1
execute if data storage _ n[-4][4] run scoreboard players add ng _ 1
execute unless data storage _ n[-4][-4][3] run scoreboard players add ng _ 1
execute if data storage _ n[-4][-4][4] run scoreboard players add ng _ 1
execute unless data storage _ n[-4][-4][-4][3] run scoreboard players add ng _ 1
execute if data storage _ n[-4][-4][-4][4] run scoreboard players add ng _ 1
execute unless data storage _ n[-4][-4][-4][-4][3] run scoreboard players add ng _ 1
execute if data storage _ n[-4][-4][-4][-4][4] run scoreboard players add ng _ 1
execute unless data storage _ n[-4][-4][-4][-4][-4][3] run scoreboard players add ng _ 1
execute if data storage _ n[-4][-4][-4][-4][-4][4] run scoreboard players add ng _ 1
execute unless data storage _ n[-4][-4][-4][-4][-4][-4][3] run scoreboard players add ng _ 1
execute if data storage _ n[-4][-4][-4][-4][-4][-4][4] run scoreboard players add ng _ 1
execute unless data storage _ n[-4][-4][-4][-4][-4][-4][-4][3] run scoreboard players add ng _ 1
execute if data storage _ n[-4][-4][-4][-4][-4][-4][-4][4] run scoreboard players add ng _ 1

# 2. n の深さがちょうど 8 か
execute unless data storage _ n[-4][-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute unless data storage _ n[-4][-4][-4][-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (n が深さ 8 に届いていない)
execute if data storage _ n[-4][-4][-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ n[-4][-4][-4][-4][-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (n が深さ 8 より深い)

# 3. w<d> の深さがちょうど d か
execute unless data storage _ w1[-4] run scoreboard players add ng _ 1
execute unless data storage _ w1[-4] run say [nested_path_access] verify: NG (w1 が深さ 1 に届いていない)
execute if data storage _ w1[-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w1[-4][-4] run say [nested_path_access] verify: NG (w1 が深さ 1 より深い)
execute unless data storage _ w2[-4][-4] run scoreboard players add ng _ 1
execute unless data storage _ w2[-4][-4] run say [nested_path_access] verify: NG (w2 が深さ 2 に届いていない)
execute if data storage _ w2[-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w2[-4][-4][-4] run say [nested_path_access] verify: NG (w2 が深さ 2 より深い)
execute unless data storage _ w3[-4][-4][-4] run scoreboard players add ng _ 1
execute unless data storage _ w3[-4][-4][-4] run say [nested_path_access] verify: NG (w3 が深さ 3 に届いていない)
execute if data storage _ w3[-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w3[-4][-4][-4][-4] run say [nested_path_access] verify: NG (w3 が深さ 3 より深い)
execute unless data storage _ w4[-4][-4][-4][-4] run scoreboard players add ng _ 1
execute unless data storage _ w4[-4][-4][-4][-4] run say [nested_path_access] verify: NG (w4 が深さ 4 に届いていない)
execute if data storage _ w4[-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w4[-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (w4 が深さ 4 より深い)
execute unless data storage _ w5[-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute unless data storage _ w5[-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (w5 が深さ 5 に届いていない)
execute if data storage _ w5[-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w5[-4][-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (w5 が深さ 5 より深い)
execute unless data storage _ w6[-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute unless data storage _ w6[-4][-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (w6 が深さ 6 に届いていない)
execute if data storage _ w6[-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w6[-4][-4][-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (w6 が深さ 6 より深い)
execute unless data storage _ w7[-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute unless data storage _ w7[-4][-4][-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (w7 が深さ 7 に届いていない)
execute if data storage _ w7[-4][-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w7[-4][-4][-4][-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (w7 が深さ 7 より深い)
execute unless data storage _ w8[-4][-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute unless data storage _ w8[-4][-4][-4][-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (w8 が深さ 8 に届いていない)
execute if data storage _ w8[-4][-4][-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w8[-4][-4][-4][-4][-4][-4][-4][-4][-4] run say [nested_path_access] verify: NG (w8 が深さ 8 より深い)

# 4. 書き込みベンチを通しても構造が壊れないか
function nested_path_access:depth_1w
function nested_path_access:depth_2w
function nested_path_access:depth_3w
function nested_path_access:depth_4w
function nested_path_access:depth_5w
function nested_path_access:depth_6w
function nested_path_access:depth_7w
function nested_path_access:depth_8w
execute unless data storage _ w1[-4] run scoreboard players add ng _ 1
execute if data storage _ w1[-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w1[-4][0] run scoreboard players add ng _ 1
execute if data storage _ w1[-4][0] run say [nested_path_access] verify: NG (w1 の末端が [] に戻っていない)
execute unless data storage _ w2[-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w2[-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w2[-4][-4][0] run scoreboard players add ng _ 1
execute if data storage _ w2[-4][-4][0] run say [nested_path_access] verify: NG (w2 の末端が [] に戻っていない)
execute unless data storage _ w3[-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w3[-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w3[-4][-4][-4][0] run scoreboard players add ng _ 1
execute if data storage _ w3[-4][-4][-4][0] run say [nested_path_access] verify: NG (w3 の末端が [] に戻っていない)
execute unless data storage _ w4[-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w4[-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w4[-4][-4][-4][-4][0] run scoreboard players add ng _ 1
execute if data storage _ w4[-4][-4][-4][-4][0] run say [nested_path_access] verify: NG (w4 の末端が [] に戻っていない)
execute unless data storage _ w5[-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w5[-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w5[-4][-4][-4][-4][-4][0] run scoreboard players add ng _ 1
execute if data storage _ w5[-4][-4][-4][-4][-4][0] run say [nested_path_access] verify: NG (w5 の末端が [] に戻っていない)
execute unless data storage _ w6[-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w6[-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w6[-4][-4][-4][-4][-4][-4][0] run scoreboard players add ng _ 1
execute if data storage _ w6[-4][-4][-4][-4][-4][-4][0] run say [nested_path_access] verify: NG (w6 の末端が [] に戻っていない)
execute unless data storage _ w7[-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w7[-4][-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w7[-4][-4][-4][-4][-4][-4][-4][0] run scoreboard players add ng _ 1
execute if data storage _ w7[-4][-4][-4][-4][-4][-4][-4][0] run say [nested_path_access] verify: NG (w7 の末端が [] に戻っていない)
execute unless data storage _ w8[-4][-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w8[-4][-4][-4][-4][-4][-4][-4][-4][-4] run scoreboard players add ng _ 1
execute if data storage _ w8[-4][-4][-4][-4][-4][-4][-4][-4][0] run scoreboard players add ng _ 1
execute if data storage _ w8[-4][-4][-4][-4][-4][-4][-4][-4][0] run say [nested_path_access] verify: NG (w8 の末端が [] に戻っていない)

execute if score ng _ matches 0 run say [nested_path_access] verify: OK
execute unless score ng _ matches 0 run say [nested_path_access] verify: NG
