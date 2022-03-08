
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
X MagesValley
X SentinelWood
X ShieldGate (Cluster)
- ShoresideExpanse (Cluster)
- StondesideForest (Cluster)
X TheBrokenRoad
X TheCauldrons
- TheGoldenGranary (Ruins)
X Treetower
- Wildholds (Cluster)
X Borderlands
X CanalLake
- GreatCity (Cluster)
X Greenbough
- GreengoldPlains (Cluster)
X LostBarony
"""

static func check(dim, map):
	# check x and y dimensions
	assert(map.size() == dim)
	for row in map:
		assert(row.size() == dim)

# create square 2d array
static func create(dim, fill):
	var map = []
	for y in range(dim):
		var row = []
		for x in range(dim):
			row.append(fill)
		map.append(row)
	return map

static func neighbours(dim, map, x, y, swapXY=false):
	if swapXY:
		var t = y
		y = x
		x = t
	var c = map[y][x]
	var l = map[y][x - 1] if x > 0 else BO
	var r = map[y][x + 1] if x < (dim - 1) else BO
	var t = map[y - 1][x] if y > 0 else BO
	var b = map[y + 1][x] if y < (dim - 1) else BO
	return {center = c, left = l, right = r, top = t, bottom = b}

static func clusters_find_unchecked(dim, map_checked):
	for y in range(dim):
		for x in range(dim):
			if !map_checked[y][x]:
				return {x = x, y = y}
	return null

static func clusters_size(dim, map, what, map_checked, x, y):
	if map_checked[y][x]:
		return 0
	map_checked[y][x] = true
	if map[y][x] != what:
		return 0
	var size = 1
	size += clusters_size(dim, map, what, map_checked, x - 1, y) if x > 0 else 0
	size += clusters_size(dim, map, what, map_checked, x, y - 1) if y > 0 else 0
	size += clusters_size(dim, map, what, map_checked, x + 1, y) if x < (dim - 1) else 0
	size += clusters_size(dim, map, what, map_checked, x, y + 1) if y < (dim - 1) else 0
	return size

static func clusters(dim, map, what):
	var map_checked = create(dim, false)

	var result = []
	for n in range(dim * dim): # impossible to have more cluster than cells
		var unchecked = clusters_find_unchecked(dim, map_checked)
		if unchecked == null:
			break
		var size = clusters_size(dim, map, what, map_checked, unchecked.x, unchecked.y)
		if size > 0:
			result.append(size)

	result.sort()
	result.invert()
	return result

static func score_greenbough(dim, map):
	check(dim, map)
	var score = 0

	for swapXY in [false, true]:
		for y in range(dim):
			var at_least_one = false
			for x in range(dim):
				if neighbours(dim, map, x, y, swapXY).center == FO:
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

	for swapXY in [false, true]:
		for y in range(dim):
			var complete = true
			for x in range(dim):
				if neighbours(dim, map, x, y, swapXY).center == EM:
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

# takes only a few ms (use OS.get_system_time_msecs()) despite brute forcing through all possibilites
static func score_lost_barony(dim, map):
	check(dim, map)

	for n in range(dim, 0, -1):
		for y_start in range(dim - n + 1):
			for x_start in range(dim - n + 1):
				var filled = true
				for y in range(n):
					for x in range(n):
						if map[y + y_start][x + x_start] == EM:
							filled = false
				if filled:
					return n

	# everything empty, should be impossible on a regular map because of mountains
	return 0
	
static func score_shieldgate(dim, map):
	check(dim, map)
	
	var c = clusters(dim, map, VI)
	
	if c.size() < 2:
		return 0
	else:
		return c[1] * 2


static func test():
	check(5, create(5, EM))
	assert(clusters(4, [[EM, EM, EM, WA], [EM, WA, WA, WA], [WA, EM, EM, EM], [EM, EM, WA, WA]], WA) == [4, 2, 1])

	assert(score_greenbough(3, [[WA, WA, FO], [FO, FO, WA], [WA, WA, WA]]) == 5)
	assert(score_mages_valley(3, [[FA, WA, EM], [WA, MO, FA], [WA, FA , EM]]) == 6)
	assert(score_the_cauldrons(4, [[EM, WA, WA, EM], [WA, EM, WA, EM], [EM, WA, EM, EM], [EM, EM, EM, EM]]) == 2)
	assert(score_borderlands(3, [[WA, WA, WA], [WA, WA, EM], [WA, EM, EM]]) == 12)
	assert(score_treetower(4, [[FO, EM, FO, MO], [FO, FO, FO, WA], [MO, WA, WA, EM], [EM, EM, WA, MO]]) == 2)
	assert(score_sentinel_wood(4, [[FO, EM, FO, MO], [FO, FO, FO, WA], [MO, WA, WA, EM], [EM, EM, WA, MO]]) == 3)
	assert(score_the_broken_road(3, [[WA, EM, WA], [EM, WA, EM], [WA, EM, WA]]) == 6)
	assert(score_canal_lake(2, [[FA, WA], [WA, FO]]) == 3)
	assert(score_lost_barony(3, [[WA, WA, EM], [WA, WA, WA], [EM, WA, EM]]) == 2)
	assert(score_shieldgate(6, [[VI, VI, EM, EM, EM, EM], [EM, VI, VI, EM, VI, VI], [EM, VI, VI, EM, EM, VI], [EM, EM, EM, EM, EM, EM], [EM, EM, EM, EM, EM, EM], [EM, EM, EM, EM, EM, EM]]) == 6)
