local pink_bullet = {}

function pink_bullet.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 0.0, -160.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
end

function pink_bullet.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)
	velx = math.sin(timer * 8) * 64

	-- move the object
	enemy_setObjectVel(gameobject, velx, vely)
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
end

function pink_bullet.oncollision(gameobject, game)
	x, y = enemy_getObjectPos(gameobject)
	vis = game_getVisualEffectList(game)
	prefabs.addPrefab(vis, x, y, "explosion")
	return true
end

function pink_bullet.oncollisionwithplayer(gameobject, game)	
	return true
end

return pink_bullet
