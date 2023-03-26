local bomb_shard = {}

function bomb_shard.start(gameobject)
	-- Set object's velocity
	local angle = math.random() * 3.14159 * 2.0
	enemy_setObjectVel(gameobject, math.cos(angle) * 160.0, math.sin(angle) * 160.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
end

function bomb_shard.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)
	
	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)

	if timer >= 1.0 then 
		enemy_setObjectPos(gameobject, -9999.0, -9999.0)
		enemy_setObjectTimer(gameobject, 0.0)
		return
	end

	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
end

function bomb_shard.oncollision(gameobject, game)
	x, y = enemy_getObjectPos(gameobject)
	vis = game_getVisualEffectList(game)
	prefabs.addPrefab(vis, x, y, "explosion")
	return true
end

function bomb_shard.oncollisionwithplayer(gameobject, game)	
	return true
end

return bomb_shard
