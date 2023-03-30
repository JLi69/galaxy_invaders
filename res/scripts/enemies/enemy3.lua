local enemy3 = {}

-- run this upon enemy start
function enemy3.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 96.0, 32.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
	enemy_setObjectHealth(gameobject, 3)
	enemy_setObjectScore(gameobject, 20)
end

function enemy3.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)

	if timer >= 2.5 then
		-- shoot
		if math.random() < 0.1 then
			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x, y, "purple_bullet")
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
function enemy3.oncollision(gameobject, game)			
	health = enemy_getObjectHealth(gameobject)
	health = health - 1
	enemy_setObjectHealth(gameobject, health)	

	if health <= 0 then
		x, y = enemy_getObjectPos(gameobject)
		vis = game_getVisualEffectList(game)
		prefabs.addPrefab(vis, x, y, "explosion")
	else
		x, y = enemy_getObjectPos(gameobject)
		enemies = game_getEnemyList(game)
		prefabs.addPrefab(enemies, x, y, "purple_bullet")
	end

	-- Delete object if health is less than or equal to 0
	return health <= 0 
end

return enemy3
