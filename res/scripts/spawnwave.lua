function spawnwave(enemies, waveNum)	
	if waveNum == 0 then
		-- spawn first wave
		for x = -1, 1 do
			prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300, "enemy")
		end
	elseif waveNum == 1 then
		-- spawn second wave
		for y = 0, 3 do
			for x = -2, 2 do			
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy")
			end
		end
	elseif waveNum == 2 then
		-- spawn third wave
		for y = 0, 4 do
			for x = -(3 - y), (3 - y) do		
				prefabs.addPrefab(enemies, x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, "enemy")
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
