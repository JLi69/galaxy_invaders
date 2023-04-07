local math = require("math")
local infinitemode = {}

--[[
-- # = enemy
-- all shapes start at y = 300
-- all rows are centered at x = 0
--]]

local shapes = {
	{
		"#####",
		"#.#.#",
		"#####",
		"#.#.#",
		"#####",
	},
	
	{
		".###.",
		"#.#.#",
		"#.#.#",
		".###."
	},

	{
		"...#...",
		"..###..",
		".#####.",
		"#######"
	},

	{
		"..###...",
		".#.#.#..",
		"#.....#.",
		".#.#.#..",
		"..###...",
	},

	{
		"..#.#.#..",
    	".#.#.#.#.",
    	"#.#.#.#.#",
    	".#.#.#.#.",
    	"..#.#.#..",
	},

	{
		"#######",
		"#.....#",
		"#.###.#",
		"#.#.#.#",
		"#.###.#",
		"#.....#",
		"#######",
	},


	{
		"#####",
		".###.",
		"..#..",
		".###.",
		"#####",
	},

	{
		".#####.",
    	"#.###.#",
    	"..#.#..",
    	"..#.#..",
    	"#.###.#",
    	".#####.",
	},

	{
		".#####.",
		".#####.",
		".#####.",
		"..###..",
		"..###..",
		"...#...",
	},

	{
		"###...",
		"###...",
		"###...",
		"...###",
		"...###",
		"...###",
	},

	{
		"..###..",
		"..###..",
		"###.###",
		"##...##",
		"###.###",
		"..###..",
		"..###..",
	},

	{
		"#####",
		"#####",
	},

	{
		"#######",
		".#####.",
		"..###..",
		"...#...",
	},

	{
		"#####",
		"#####",
		"#####",
		"#####",
	},
	
	{
		"###",
		"###",
		"###",
	},

	{
		"..#..",
		".###.",
		"#####",
		".###.",
		"..#..",
	},

	{
		"#...#...#",
		".#.#.#.#.",
		"..#...#..",
	},

	{
		"###.###.#",
		"#.#.#.#.#",
		"#.#.#.#.#",
		"#.###.###"
	}
}

function infinitemode.spawnwave(enemies)
	-- Generate random index
	local ind = math.floor(math.random() * #shapes) + 1
	local rand = math.random()

	if rand < 0.75 then	
		local numOfTypes = math.ceil(rand / 0.25)
		-- one type of alien
		local enemyTypes = {
			"enemy",		
			"enemy2",
			"enemy3",
			"circle_alien",	
			"star_alien",	
			"shielded_alien",	
			"eye_alien",	
			"bomb_alien",
			"slime_alien",
		}
		local enemyInds = {}
		for i = 1, numOfTypes do
			enemyInds[i] = math.floor(math.random() * #enemyTypes) + 1
		end
		-- local enemyInd = math.floor(math.random() * #enemyTypes) + 1
		for y = 1, #shapes[ind] do
			for x = 1, #shapes[ind][y] do
				if string.sub(shapes[ind][y], x, x) == "#" then	
					local enemyInd = math.floor(math.random() * #enemyInds) + 1
					prefabs.addPrefab(enemies, (x - #shapes[ind][y] / 2.0 - 0.5) * SPRITE_SIZE * 1.5, 300 - (y - 1.0) * 1.1 * SPRITE_SIZE, enemyTypes[enemyInds[enemyInd]]) 
				end
			end
		end
	else
		-- random chaos
		local enemyTypes = {
			"enemy",		
			"enemy2",
			"enemy3",
			"circle_alien",	
			"star_alien",	
			"shielded_alien",	
			"ufo",	
			"eye_alien",	
			"bomb_alien",
			"slime_alien",
		}

		for y = 1, #shapes[ind] do
			for x = 1, #shapes[ind][y] do
				if string.sub(shapes[ind][y], x, x) == "#" then		
					local enemyInd = math.floor(math.random() * #enemyTypes) + 1
					prefabs.addPrefab(enemies, (x - #shapes[ind][y] / 2.0 - 0.5) * SPRITE_SIZE * 1.5, 300 - (y - 1.0) * 1.1 * SPRITE_SIZE, enemyTypes[enemyInd]) 
				end
			end
		end
	end
end

return infinitemode
