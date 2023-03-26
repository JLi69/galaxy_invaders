local enemy_bullet = {}

function enemy_bullet.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 0.0, -160.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
end

function enemy_bullet.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)
	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
end

function enemy_bullet.oncollision(gameobject, game)
	x, y = enemy_getObjectPos(gameobject)
	vis = game_getVisualEffectList(game)
	prefabs.addPrefab(vis, x, y, "explosion")
	return true
end

function enemy_bullet.oncollisionwithplayer(gameobject, game)	
	return true
end

return enemy_bullet
