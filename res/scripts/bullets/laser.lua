local laser = {}

function laser.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 0.0, 0.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
end

function laser.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	
	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)

	if timer >= 0.02 and enemy_getObjectMode(gameobject) == 0 and y > -320.0 then
		enemy_setObjectMode(gameobject, 1)
		enemies = game_getEnemyList(game)	
		prefabs.addPrefab(enemies, x, y - SPRITE_SIZE / 4.0, "laser")
	end

	if timer >= 1.5 then 
		enemy_setObjectPos(gameobject, -9999.0, -9999.0)
		enemy_setObjectTimer(gameobject, 0.0)
		return
	end
end

function laser.oncollision(gameobject, game)
	x, y = enemy_getObjectPos(gameobject)
	vis = game_getVisualEffectList(game)
	prefabs.addPrefab(vis, x, y, "explosion")
	return false
end

function laser.oncollisionwithplayer(gameobject, game)	
	return true
end

return laser
