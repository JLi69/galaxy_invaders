local math = require("math")

local spawnWaveFunctions = {
	function(enemies)
		-- spawn first wave 
		for y = 0, 1 do 
			for x = -2, 2 do	
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy") 
			end 
		end
	end,

	function(enemies)
		-- spawn second wave
		for y = 0, 4 do
			for x = -(3 - y), (3 - y) do		
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy")
			end
		end
	end,

	function(enemies)
		-- spawn third wave
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
		-- spawn fourth wave
		for y = 0, 2 do
			for x = -1, 1 do			
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy2")
			end
		end
	end,

	function(enemies)
		-- spawn fifth wave
		for y = 0, 5 do
			for x = -2, 2 do			
				if (y - 3) * (y - 3) + x * x <= 2 * 2 then
					prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy3")
				end
			end
		end
	end,

	function(enemies)
		-- spawn sixth wave
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
		-- spawn seventh wave
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
		-- spawn eigth wave
		local num = 12
		local radius = 150.0
		for theta = 0, num do
			angle = theta * 3.14159 * 2.0  / num
			prefabs.addPrefab(enemies, math.cos(angle) * radius, 300 - radius + math.sin(angle) * radius, "square_alien")	
			
			if y <= 0 then
				dy = 1
			elseif y >= 2 then
				dy = -1
			end
		end

		num = 6

		for theta = 0, num do
			angle = theta * 3.14159 * 2.0  / num
			prefabs.addPrefab(enemies, math.cos(angle) * radius / 2, 300 - radius + math.sin(angle) * radius / 2, "square_alien")	
			
			if y <= 0 then
				dy = 1
			elseif y >= 2 then
				dy = -1
			end
		end
	end,

	-- Final function will spawn all other waves
	function(enemies)
		-- Spawn all other waves
		for y = 0, 5 do
			for x = -2, 2 do					
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy")
			end
		end
	end
}

function spawnwave(enemies, waveNum)
	if waveNum + 1 <= #spawnWaveFunctions then 
		spawnWaveFunctions[waveNum + 1](enemies)
	else
		spawnWaveFunctions[#spawnWaveFunctions](enemies)
	end
end
