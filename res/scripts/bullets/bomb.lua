local bomb = {}

function bomb.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 0.0, -240.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
end

function bomb.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)
	
	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)

	if timer >= 1.5 then 
		-- explode
		if math.random() < 0.5 then
			vis = game_getVisualEffectList(game)
			prefabs.addPrefab(vis, x, y, "explosion")

			enemies = game_getEnemyList(game)
			for i = 0, 15 do
				prefabs.addPrefab(enemies, x, y, "bomb_shard")
			end

			enemy_setObjectPos(gameobject, -9999.0, -9999.0)
			return	
		end
		enemy_setObjectTimer(gameobject, 0.0)
	end

	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
end

function bomb.oncollision(gameobject, game)
	x, y = enemy_getObjectPos(gameobject)
	vis = game_getVisualEffectList(game)
	prefabs.addPrefab(vis, x, y, "explosion")
	return true
end

function bomb.oncollisionwithplayer(gameobject, game)	
	return true
end

return bomb 
