local math = require("math")
local infintemode = require("res.scripts.infinitemode")

local spawnWaveFunctions = {
	function(enemies)
		for y = 0, 1 do 
			for x = -2, 2 do	
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy") 
			end 
		end
	end,

	function(enemies)
		for y = 0, 4 do
			for x = -(3 - y), (3 - y) do		
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy")
			end
		end
	end,	

	function(enemies)
		for y = 0, 3 do
			for x = -2, 2 do			
				if y == 0 or y == 3 or x == -2 or x == 2 then
					prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy")
				else
					prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy2")
				end	
			end
		end
	end,

	function(enemies)
		for y = 0, 2 do
			for x = -1, 1 do			
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy2")
			end
		end
	end,

	function(enemies)
		for y = 0, 5 do
			for x = -2, 2 do			
				if (y - 3) * (y - 3) + x * x <= 2 * 2 then
					prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy3")
				end
			end
		end
	end,

	function(enemies)
		for y = 0, 3 do
			for x = -2, 2 do			
				enemyType = ""
				if y == 0 then
					enemyType = "enemy3"
				elseif y == 1 then
					enemyType = "enemy2"
				elseif y <= 4 then
					enemyType = "enemy"	
				end

				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, enemyType)	
			end
		end
	end,

	function(enemies)
		for y = 0, 2 do
			for x = -3, 3 do
				if (x + y) % 2 == 0 then
					prefabs.addPrefab(enemies, 1.5 * SPRITE_SIZE * x, 300 - 1.2 * SPRITE_SIZE * y, "slime_alien")	
				end
			end
		end
	end,

	function(enemies)
		y = 2
		local dy = -1
		for x = -6, 6 do	
			prefabs.addPrefab(enemies, x * SPRITE_SIZE, 300 - y * SPRITE_SIZE, "circle_alien")	
			y = y + dy
			
			if y <= 0 then
				dy = 1
			elseif y >= 2 then
				dy = -1
			end
		end
	end,

	function(enemies)
		local num = 12
		local radius = 150.0
		for theta = 0, num - 1 do
			angle = theta * 3.14159 * 2.0  / num
			prefabs.addPrefab(enemies, math.cos(angle) * radius, 300 - radius + math.sin(angle) * radius, "square_alien")	
			
			if y <= 0 then
				dy = 1
			elseif y >= 2 then
				dy = -1
			end
		end

		num = 6

		for theta = 0, num - 1 do
			angle = theta * 3.14159 * 2.0  / num
			prefabs.addPrefab(enemies, math.cos(angle) * radius / 2, 300 - radius + math.sin(angle) * radius / 2, "square_alien")	
			
			if y <= 0 then
				dy = 1
			elseif y >= 2 then
				dy = -1
			end
		end
	end,
	
	function(enemies)
		for y = 0, 6 do
			for x = -3, 3 do
				if (math.floor(math.sin(x) * 3 + 3) <= y and 
					math.floor(math.sin(x - 1) * 3 + 3) >= y and 
					math.floor(math.sin(x - 1) * 3 + 3) >= math.floor(math.sin(x) * 3 + 3)) or
					
					(math.floor(math.sin(x) * 3 + 3) >= y and 
					math.floor(math.sin(x - 1) * 3 + 3) <= y and 
					math.floor(math.sin(x - 1) * 3 + 3) <= math.floor(math.sin(x) * 3 + 3)) then
					prefabs.addPrefab(enemies, 1.5 * SPRITE_SIZE * x, 300 - SPRITE_SIZE * y, "star_alien")
				end	
			end
		end
	end,

	function(enemies)
		for y = 0, 3 do 
			for x = -2, 2 do	
				local enemyType = ""	

				if y < 2 then
					enemyType = "shielded_alien"
				elseif (x + y) % 2 == 0 then
					enemyType = "enemy"
				else
					enemyType = "star_alien"
				end	

				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, enemyType) 
			end 
		end
	end,

	function(enemies)
		for x = -2, 2 do
			prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300, "shielded_alien") 
		end

		prefabs.addPrefab(enemies, 320.0, 300 - SPRITE_SIZE, "ufo") 
		prefabs.addPrefab(enemies, 160.0, 300 - 3.0 * SPRITE_SIZE, "ufo") 
		prefabs.addPrefab(enemies, -320.0, 300 - 2.0 * SPRITE_SIZE, "ufo") 
		prefabs.addPrefab(enemies, -160.0, 300 - 4.0 * SPRITE_SIZE, "ufo") 
	end,

	function(enemies)
		local enemyTypes = { "shielded_alien", "enemy3", "circle_alien" }
		for y = 0, 2 do	
			for x = -2, 2 do
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, enemyTypes[y + 1]) 
			end	
		end

		prefabs.addPrefab(enemies, 320.0, 300 - SPRITE_SIZE * 3, "ufo")
		prefabs.addPrefab(enemies, -320.0, 300 - SPRITE_SIZE * 3, "ufo") 
	end,

	function(enemies)
		prefabs.addPrefab(enemies, 320.0, 300 - SPRITE_SIZE * 3, "ufo")
		prefabs.addPrefab(enemies, -320.0, 300 - SPRITE_SIZE * 3, "ufo")
		prefabs.addPrefab(enemies, 320.0 - 1.5 * SPRITE_SIZE, 300 - SPRITE_SIZE * 2, "ufo")
		prefabs.addPrefab(enemies, -320.0 + 1.5 * SPRITE_SIZE, 300 - SPRITE_SIZE * 2, "ufo")
	
		for y = 0, 1 do
			for x = -3, 3 do
				if x < -1 or x > 1 then
					prefabs.addPrefab(enemies, 1.5 * SPRITE_SIZE * x, 300 - SPRITE_SIZE * y, "enemy2")
				else
					prefabs.addPrefab(enemies, 1.5 * SPRITE_SIZE * x, 300 - SPRITE_SIZE * y, "star_alien")
				end
			end
		end
	end,	
	
	function(enemies)
		for y = 0, 2 do
			for x = -3, 3 do
				if y == 0 then
					prefabs.addPrefab(enemies, 1.5 * SPRITE_SIZE * x, 300 - 1.2 * SPRITE_SIZE * y, "eye_alien")
				elseif y <= 2 and x >= -2 and x <= 2 then
					prefabs.addPrefab(enemies, 1.5 * SPRITE_SIZE * x, 300 - 1.2 * SPRITE_SIZE * y, "bomb_alien")
				end	
			end
		end
	end,	

	function(enemies)	
		prefabs.addPrefab(enemies, 0, 200, "superweapon")
	end,

	-- Final function will spawn all other waves
	function(enemies)
		-- Spawn all other waves
		infintemode.spawnwave(enemies)
	end
}

function spawnwave(enemies, waveNum)
	if waveNum + 1 <= #spawnWaveFunctions then 
		spawnWaveFunctions[waveNum + 1](enemies)
	else
		spawnWaveFunctions[#spawnWaveFunctions](enemies)
	end
end

function waveCount()
	return #spawnWaveFunctions
end
