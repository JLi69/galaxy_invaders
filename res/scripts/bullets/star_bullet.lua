local star_bullet = {}

function star_bullet.start(gameobject)
	-- Set object's velocity
	local angle = -math.random() * 3.14159 / 2.0 - 3.14159 / 4.0
	enemy_setObjectVel(gameobject, 160.0 * math.cos(angle), 160.0 * math.sin(angle))
	enemy_setObjectRotation(gameobject, -(angle + 3.14159 / 2.0))
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
end

function star_bullet.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)
	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
end

function star_bullet.oncollision(gameobject, game)
	x, y = enemy_getObjectPos(gameobject)
	vis = game_getVisualEffectList(game)
	prefabs.addPrefab(vis, x, y, "explosion")
	return true
end

function star_bullet.oncollisionwithplayer(gameobject, game)	
	return true
end

return star_bullet
