local enemy = {}

function enemy.start(gameobject)
	-- Set object's velocity
	_setObjectVel(gameobject, 32.0, 0.0)
end

function enemy.update(gameobject, timepassed)
	-- Get object's position
	x, y = _getObjectPos(gameobject)
	-- Get velocity
	velx, vely = _getObjectVel(gameobject)
	
	-- Bounce off of edges of screen
	if x < -320.0 then
		_setObjectVel(gameobject, -velx, vely)
		_setObjectPos(gameobject, -300.0, y - 16.0)
	elseif x > 320.0 then
		_setObjectVel(gameobject, -velx, vely)
		_setObjectPos(gameobject, 300.0, y - 16.0)
	end
end

return enemy 
