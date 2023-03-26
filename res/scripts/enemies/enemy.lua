math = require("math")
local enemy = {}

-- run this upon enemy start
function enemy.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 32.0, 0.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)

	enemy_setObjectScore(gameobject, 5)
end

function enemy.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)

	if timer >= 1.0 then
		-- shoot
		if math.random() < 0.1 then
			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x, y, "enemy_bullet")
		end
		enemy_setObjectTimer(gameobject, 0)
	end

	-- Bounce off of edges of screen
	if x < -320.0 then	
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, -320.0, y)	
	elseif x > 320.0 then	
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, 320.0, y)
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
	x, y = enemy_getObjectPos(gameobject)
	vis = game_getVisualEffectList(game)
	prefabs.addPrefab(vis, x, y, "explosion")
	
	-- Delete object if health is less than or equal to 0
	return true
end

return enemy 
