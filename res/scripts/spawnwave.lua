function spawnwave(enemies, waveNum)	
	if waveNum == 0 then
		-- spawn first wave
		for x = -2, 2 do
			game_addEnemy(enemies,
						  x * SPRITE_SIZE * 1.5, 300, 0, 0,
						  SPRITE_SIZE, SPRITE_SIZE, 4,
						  "res/images/enemy1.png")
		end
	elseif waveNum == 1 then
		for y = 0, 3 do
			for x = -2, 2 do
				game_addEnemy(enemies,
							  x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, 0, 0,
							  SPRITE_SIZE, SPRITE_SIZE, 4,
							  "res/images/enemy1.png")
			end
		end
	elseif waveNum == 2 then
		-- spawn third wave
		for y = 0, 4 do
			for x = -(3 - y), (3 - y) do	
				game_addEnemy(enemies,
							  x * SPRITE_SIZE * 1.5, 300 - y * SPRITE_SIZE, 0, 0,
							  SPRITE_SIZE, SPRITE_SIZE, 4,
							  "res/images/enemy1.png")
			end
		end	
	end
end
