local player = {}

local SPAWN_X = 0
local SPAWN_Y = -300

function player.start(gameobject)
	enemy_setObjectMode(gameobject, 0)
	enemy_setObjectHealth(gameobject, 3)
	enemy_setObjectPos(gameobject, SPAWN_X, SPAWN_Y)
end

function player.update(gameobject, game, timepassed)
	-- Player is dead	
	if enemy_getObjectMode(gameobject) == 1 then
		if enemy_getObjectFrame(gameobject) == enemy_getObjectFrameCount(gameobject) - 1 then
			
			if enemy_getObjectHealth(gameobject) > 0 then
				enemy_setObjectMode(gameobject, 0)
				enemy_setObjectPicture(gameobject, "res/images/spaceship.png")
			else
				enemy_setObjectPicture(gameobject, nil)
			end

			enemy_setObjectPos(gameobject, SPAWN_X, SPAWN_Y)
		end	
		return
	end

	x, y = enemy_getObjectPos(gameobject)
	velx, vely = enemy_getObjectVel(gameobject)
	
	-- Bound the player's position
	if x < -320.0 then
		x = -320.0
		enemy_setObjectPos(gameobject, x, y)
	elseif x > 320.0 then
		x = 320.0
		enemy_setObjectPos(gameobject, x, y)
	end

	if y < -320.0 then
		y = -320.0
		enemy_setObjectPos(gameobject, x, y)
	elseif y > 320.0 then
		y = 320.0
		enemy_setObjectPos(gameobject, x, y)
	end

	-- move the player
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
end

function player.oncollision(gameobject, game)
	if enemy_getObjectMode(gameobject) == 0 then
		health = enemy_getObjectHealth(gameobject)
		health = health - 1
		enemy_setObjectHealth(gameobject, health)
		enemy_setObjectMode(gameobject, 1)
		enemy_setObjectFrame(gameobject, 0)	
		enemy_setObjectPicture(gameobject, "res/images/explosion.png")
	end

	return false
end

return player
