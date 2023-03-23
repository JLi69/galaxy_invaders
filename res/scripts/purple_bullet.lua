local purple_bullet = {}

function purple_bullet.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 0.0, -320.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
end

function purple_bullet.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)
	
	-- Home in on the player
	playerx, playery = game_getPlayerPos(game)
	velx = (playerx - x) * 0.6

	-- move the object
	enemy_setObjectVel(gameobject, velx, vely)
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
end

function purple_bullet.oncollision(gameobject, game)
	x, y = enemy_getObjectPos(gameobject)
	vis = game_getVisualEffectList(game)
	prefabs.addPrefab(vis, x, y, "explosion")
	return true
end

function purple_bullet.oncollisionwithplayer(gameobject, game)		
	return true
end

return purple_bullet
