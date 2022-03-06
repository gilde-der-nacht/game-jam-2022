
# TODO switch to enum later
const WA = "WATER"
const VI = "VILLAGE"
const EM = "EMPTY"
const MO = "MOUNTAIN"
const FA = "FARM"
const FO = "FOREST"

static func check(dim, map):
	# check x and y dimensions
	assert(map.size() == dim)
	for row in map:
		assert(row.size() == dim)

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
			var left = map[y][x - 1] if x > 0 else "-"
			var right = map[y][x + 1] if x < (dim - 1) else "-"
			var top = map[y - 1][x] if y > 0 else "-"
			var bottom = map[y + 1][x] if y < (dim - 1) else "-"
			var center = map[y][x]
			
			var mountain_there = (left == MO) or (right == MO) or (top == MO) or (bottom == MO)
			if mountain_there:
				if center == WA:
					score += 2
				if center == FA:
					score += 1
	
	return score

static func test():
	check(2, [[0, 0], [0, 0]])
	
	assert(score_greenbough(3, [[WA, WA, FO], [FO, FO, WA], [WA, WA, WA]]) == 5)
	assert(score_mages_valley(3, [[FA, WA, EM], [WA, MO, FA], [WA, FA , EM]]) == 6)
