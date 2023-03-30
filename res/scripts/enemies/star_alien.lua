math = require("math")
local star_alien = {}

-- run this upon enemy start
function star_alien.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 32.0, 0.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)

	enemy_setObjectHealth(gameobject, 3)
	enemy_setObjectScore(gameobject, 35)
end

function star_alien.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)

	if timer >= 2.0 then
		playerx, playery = game_getPlayerPos(game)	

		-- shoot
		if math.random() < 0.2 and enemy_getObjectMode(gameobject) == 0 then
			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x, y, "star_bullet")
		elseif math.random() < 0.03 and math.abs(x - playerx) > 64.0 then
			-- Falling star attack
			enemy_setObjectMode(gameobject, 1) 
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

	if enemy_getObjectMode(gameobject) == 1 then
		playerx, playery = game_getPlayerPos(game)	
		if playerx < x - 8.0 then
			enemy_setObjectVel(gameobject, -140.0, 0.0)	
		elseif playerx > x + 8.0 then
			enemy_setObjectVel(gameobject, 140.0, 0.0)	
		else
			enemy_setObjectVel(gameobject, 0.0, -480.0)
			enemy_setObjectMode(gameobject, 2)
		end
	elseif enemy_getObjectMode(gameobject) == 2 then
		if y < -320.0 then	
			enemy_setObjectVel(gameobject, 0.0, 360.0)
			enemy_setObjectMode(gameobject, 3)
		end
	elseif enemy_getObjectMode(gameobject) == 3 then
		if y > 300.0 then	
			enemy_setObjectVel(gameobject, 32.0, 0.0)
			enemy_setObjectMode(gameobject, 0)
		end
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
function star_alien.oncollision(gameobject, game)
	local health = enemy_getObjectHealth(gameobject)
	health = health - 1
	enemy_setObjectHealth(gameobject, health)

	if health <= 0 then
		x, y = enemy_getObjectPos(gameobject)
		vis = game_getVisualEffectList(game)
		prefabs.addPrefab(vis, x, y, "explosion")
	end

	-- Delete object if health is less than or equal to 0
	return health <= 0
end

return star_alien 
