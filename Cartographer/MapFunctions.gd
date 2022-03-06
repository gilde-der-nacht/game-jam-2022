
# TODO switch to enum later
const WA = "WATER"
const VI = "VILLAGE"
const EM = "EMPTY"
const MO = "MOUNTAIN"
const FA = "FARM"
const FO = "FOREST"

# TODO instead of repeating half of the code, rotate board and call the same score function twice?
static func score_greenbough(dim, map):
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

static func check(dim, map):
	# check x and y dimensions
	assert(map.size() == dim)
	for row in map:
		assert(row.size() == dim)

static func test():
	check(2, [[0, 0], [0, 0]])
	
	assert(score_greenbough(3, [[WA, WA, FO], [FO, FO, WA], [WA, WA, WA]]) == 5)
