-- TODO: clean up this function

function spawnwave(enemies, waveNum)
	waveNum = 4

	if waveNum == 0 then
		-- spawn first wave
		for y = 0, 1 do
			for x = -2, 2 do	
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy")
			end
		end
	elseif waveNum == 1 then
		-- spawn second wave
		for y = 0, 4 do
			for x = -(3 - y), (3 - y) do		
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy")
			end
		end elseif waveNum == 2 then
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
	elseif waveNum == 3 then
		-- spawn fourth wave
		for y = 0, 3 do
			for x = -1, 1 do			
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy2")
			end
		end
	elseif waveNum == 4 then
		-- spawn fifth wave
		for y = 0, 5 do
			for x = -2, 2 do			
				if (y - 3) * (y - 3) + x * x <= 2 * 2 then
					prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy3")
				end
			end
		end
	elseif waveNum == 5 then
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
	else
		-- Spawn all other waves
		for y = 0, 5 do
			for x = -2, 2 do					
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy")
			end
		end
	end
end
