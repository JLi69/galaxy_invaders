local enemy = {}

function enemy.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 32.0, 0.0)
end

function enemy.update(gameobject, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)
	
	-- Bounce off of edges of screen
	if x < -320.0 then
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, -300.0, y - 16.0)
	elseif x > 320.0 then
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, 300.0, y - 16.0)
	end
end

return enemy 
