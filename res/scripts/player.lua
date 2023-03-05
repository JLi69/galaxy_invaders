local player = {}

function player.start(gameobject)

end

function player.update(gameobject, game, timepassed)	
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
	return false
end

return player
