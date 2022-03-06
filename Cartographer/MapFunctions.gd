
# TODO switch to enum later
const WA = "WATER"
const VI = "VILLAGE"
const EM = "EMPTY"
const MO = "MOUNTAIN"
const FA = "FARM"
const FO = "FOREST"
const RU = "RUIN"
const BO = "-" # Border

"""
X Mages Valley
X Sentinel Wood
- Shield Gate (Cluster)
- Shoreside Expanse (Cluster)
- Stondeside Forest (Cluster)
X The Broken Road
X The Cauldrons
- The Golden Granary (Ruins)
X Treetower
- Wildholds (Cluster)
X Borderlands
- Canal Lake (Adjacent)
- Great City (Cluster)
X Greenbough
- Greengold Plains (Cluster)
- Lost Barony (Largest Square)
"""

static func check(dim, map):
	# check x and y dimensions
	assert(map.size() == dim)
	for row in map:
		assert(row.size() == dim)

static func neighbours(dim, map, x, y):
	var c = map[y][x]
	var l = map[y][x - 1] if x > 0 else BO
	var r = map[y][x + 1] if x < (dim - 1) else BO
	var t = map[y - 1][x] if y > 0 else BO
	var b = map[y + 1][x] if y < (dim - 1) else BO
	return {center = c, left = l, right = r, top = t, bottom = b}

# TODO instead of repeating half of the code, rotate board and call the same score function twice?
static func score_greenbough(dim, map):
	check(dim, map)
	var score = 0

	for y in range(dim):
		var at_least_one = false
		for x in range(dim):
			if map[y][x] == FO:
				at_least_one = true
		if at_least_one:
			score += 1

	for x in range(dim):
		var at_least_one = false
		for y in range(dim):
			if map[y][x] == FO:
				at_least_one = true
		if at_least_one:
			score += 1

	return score

static func score_mages_valley(dim, map):
	check(dim, map)
	var score = 0

	for y in range(dim):
		for x in range(dim):
			var n = neighbours(dim, map, x, y)
			var mountain_there = (n.left == MO) or (n.right == MO) or (n.top == MO) or (n.bottom == MO)
			if mountain_there:
				if n.center == WA:
					score += 2
				if n.center == FA:
					score += 1

	return score

static func score_the_cauldrons(dim, map):
	check(dim, map)
	var score = 0

	for y in range(dim):
		for x in range(dim):
			var n = neighbours(dim, map, x, y)
			var left_filled = (n.left != EM) or (n.left == BO)
			var right_filled = (n.right != EM) or (n.right == BO)
			var top_filled = (n.top != EM) or (n.top == BO)
			var bottom_filled = (n.bottom != EM) or (n.bottom == BO)
			var all_filled = left_filled and right_filled and top_filled and bottom_filled
			if (n.center == EM) and all_filled:
				score += 1

	return score

# TODO almost the same as score_mages_valley
static func score_treetower(dim, map):
	check(dim, map)
	var score = 0

	for y in range(dim):
		for x in range(dim):
			var n = neighbours(dim, map, x, y)
			var left_filled = (n.left != EM) or (n.left == BO)
			var right_filled = (n.right != EM) or (n.right == BO)
			var top_filled = (n.top != EM) or (n.top == BO)
			var bottom_filled = (n.bottom != EM) or (n.bottom == BO)
			var all_filled = left_filled and right_filled and top_filled and bottom_filled
			if (n.center == FO) and all_filled:
				score += 1

	return score

static func score_borderlands(dim, map):
	check(dim, map)
	var score = 0

	for y in range(dim):
		var complete = true
		for x in range(dim):
			if map[y][x] == EM:
				complete = false
		if complete:
			score += 6

	for x in range(dim):
		var complete = true
		for y in range(dim):
			if map[y][x] == EM:
				complete = false
		if complete:
			score += 6

	return score

static func score_sentinel_wood(dim, map):
	check(dim, map)
	var score = 0

	for y in range(dim):
		for x in range(dim):
			var n = neighbours(dim, map, x, y)
			var is_border = (n.left == BO) or (n.right == BO) or (n.top == BO) or (n.bottom == BO)
			if (n.center == FO) and is_border:
				score += 1

	return score

static func score_the_broken_road(dim, map):
	check(dim, map)
	var score = 0

	for y in range(dim):
		var diagonal_filled = true
		for n in range(dim - y):
			if map[n + y][n] == EM:
				diagonal_filled = false

		if diagonal_filled:
			score += 3

	return score

static func score_canal_lake(dim, map):
	check(dim, map)
	var score = 0

	for y in range(dim):
		for x in range(dim):
			var n = neighbours(dim, map, x, y)
			var water_around = (n.left == WA) or (n.right == WA) or (n.top == WA) or (n.bottom == WA)
			var farm_around = (n.left == FA) or (n.right == FA) or (n.top == FA) or (n.bottom == FA)
			if (n.center == FA) and water_around:
				score += 1
			if (n.center == WA) and farm_around:
				score += 1

	return score

static func test():
	assert(score_greenbough(3, [[WA, WA, FO], [FO, FO, WA], [WA, WA, WA]]) == 5)
	assert(score_mages_valley(3, [[FA, WA, EM], [WA, MO, FA], [WA, FA , EM]]) == 6)
	assert(score_the_cauldrons(4, [[EM, WA, WA, EM], [WA, EM, WA, EM], [EM, WA, EM, EM], [EM, EM, EM, EM]]) == 2)
	assert(score_borderlands(3, [[WA, WA, WA], [WA, WA, EM], [WA, EM, EM]]) == 12)
	assert(score_treetower(4, [[FO, EM, FO, MO], [FO, FO, FO, WA], [MO, WA, WA, EM], [EM, EM, WA, MO]]) == 2)
	assert(score_sentinel_wood(4, [[FO, EM, FO, MO], [FO, FO, FO, WA], [MO, WA, WA, EM], [EM, EM, WA, MO]]) == 3)
	assert(score_the_broken_road(3, [[WA, EM, WA], [EM, WA, EM], [WA, EM, WA]]) == 6)
	assert(score_canal_lake(2, [[FA, WA], [WA, FO]]) == 3)
