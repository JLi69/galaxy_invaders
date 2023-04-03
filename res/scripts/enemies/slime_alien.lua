math = require("math")
local slime_alien = {}

slime_alien.SPEED = 128.0

-- run this upon enemy start
function slime_alien.start(gameobject)
	-- Set object's velocity
	local velx = 0.0
	if math.random() < 0.5 then
		velx = slime_alien.SPEED
	else
		velx = -slime_alien.SPEED
	end
	
	enemy_setObjectVel(gameobject, velx, -slime_alien.SPEED)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
	enemy_setObjectHealth(gameobject, 3)
	enemy_setObjectScore(gameobject, 5)
end

function slime_alien.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)

	-- Bounce off of edges of screen
	if x < -320.0 then	
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, -320.0, y)	
	elseif x > 320.0 then	
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, 320.0, y)
	end

	if y < -320.0 then	
		enemy_setObjectVel(gameobject, velx, -vely)
		enemy_setObjectPos(gameobject, x, -320.0)	
	elseif y > 320.0 then	
		enemy_setObjectVel(gameobject, velx, -vely)
		enemy_setObjectPos(gameobject, x, 320.0)
	end
	
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)
	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed) 
end

-- run this when the enemy collides with a bullet
-- returns a value true or false,
-- if the value is true, then delete the enemy,
-- if the value is false, then do not delete the enemy
function slime_alien.oncollision(gameobject, game)		
	health = enemy_getObjectHealth(gameobject)
	health = health - 1
	enemy_setObjectHealth(gameobject, health)

	velx, vely = enemy_getObjectVel(gameobject)
	if vely < 0.0 then
		enemy_setObjectVel(gameobject, velx, -vely)
	end

	-- if out of health, explode
	if health <= 0 then
		x, y = enemy_getObjectPos(gameobject)
		vis = game_getVisualEffectList(game)
		prefabs.addPrefab(vis, x, y, "explosion")
	end
	
	-- Delete object if health is less than or equal to 0
	return health <= 0
end

return slime_alien
