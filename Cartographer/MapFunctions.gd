
# TODO switch to enum later
const WA = "WATER"
const VI = "VILLAGE"
const EM = "EMPTY"
const MO = "MOUNTAIN"
const FA = "FARM"
const FO = "FOREST"

const BO = "-" # Border

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

static func test():
	check(2, [[0, 0], [0, 0]])
	
	assert(score_greenbough(3, [[WA, WA, FO], [FO, FO, WA], [WA, WA, WA]]) == 5)
	assert(score_mages_valley(3, [[FA, WA, EM], [WA, MO, FA], [WA, FA , EM]]) == 6)
	assert(score_the_cauldrons(4, [[EM, WA, WA, EM], [WA, EM, WA, EM], [EM, WA, EM, EM], [EM, EM, EM, EM]]) == 2)
