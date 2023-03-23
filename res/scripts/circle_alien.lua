math = require("math")
local circle_alien = {}

function circle_alien.generate_speed(minSpeed, maxSpeed)
	if math.random() < 0.5 then
		return -(minSpeed + math.random() * (maxSpeed - minSpeed))
	else
		return minSpeed + math.random() * (maxSpeed - minSpeed)
	end
end

-- run this upon enemy start
function circle_alien.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 0.0, 0.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
	enemy_setObjectHealth(gameobject, 3)
	enemy_setObjectScore(gameobject, 10)
end

function circle_alien.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)

	if timer >= 2.0 and enemy_getObjectMode(gameobject) == 0 then
		-- shoot
		if math.random() < 0.2 then
			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x, y, "enemy_bullet")
		else
			enemies = game_getEnemyList(game)
			enemy_setObjectMode(gameobject, 1)
			enemy_setObjectVel(gameobject, circle_alien.generate_speed(8.0, 16.0), circle_alien.generate_speed(8.0, 32.0))
			prefabs.addPrefab(enemies, x, y, "enemy_bullet")
		end
		
		enemy_setObjectTimer(gameobject, 0)
	elseif enemy_getObjectMode(gameobject) == 1 and timer >= 5.0 then 	
		enemy_setObjectMode(gameobject, 0)
		enemy_setObjectVel(gameobject, 0.0, 0.0)
	end

	-- Bounce off of edges of screen
	if x < -320.0 then	
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, -320.0, y)	
	elseif x > 320.0 then	
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, 320.0, y)
	end

	if y < 0.0 then	
		enemy_setObjectVel(gameobject, velx, -vely)
		enemy_setObjectPos(gameobject, x, 0.0)	
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
function circle_alien.oncollision(gameobject, game)		
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

return circle_alien
