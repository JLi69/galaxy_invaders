local enemy = {}

-- run this upon enemy start
function enemy.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 32.0, 0.0)
	-- Set health
	enemy_setObjectHealth(gameobject, 2)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)
	enemy_setObjectFrameCount(gameobject, 4)
end

function enemy.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)

	-- Bounce off of edges of screen
	if x < -320.0 then	
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, -320.0, y - 16.0)	
	elseif x > 320.0 then	
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, 320.0, y - 16.0)
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
function enemy.oncollision(gameobject, game)	
	health = enemy_getObjectHealth(gameobject)
	health = health - 1
	enemy_setObjectHealth(gameobject, health)
	
	-- if out of health, explode
	if health <= 0 then
		x, y = enemy_getObjectPos(gameobject)
		vis = game_getVisualEffectList(game)
		prefabs.addPrefab(vis, x, y, "explosion")
	end
	
	-- Delete object if health is less than or equal to 0
	return health <= 0
end

return enemy 
