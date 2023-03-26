local bullet = {}

function bullet.start(gameobject)

end

function bullet.update(gameobject, game, timepassed)	
	x, y = enemy_getObjectPos(gameobject)
	velx, vely = enemy_getObjectVel(gameobject)	
	-- move the bullet 
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
end

function bullet.oncollision(gameobject, game)		
	return false
end

return bullet
