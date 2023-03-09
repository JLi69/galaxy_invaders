math = require("math")
local enemy2 = {}

function enemy2.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 32.0, 0.0)
	-- Set health
	enemy_setObjectHealth(gameobject, 4)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)
	enemy_setObjectFrameCount(gameobject, 4)
end

function enemy2.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)
	
	if timer > 2.0 then	
		if enemy_getObjectMode(gameobject) == 0 and math.random() < 0.05 then
			enemy_setObjectMode(gameobject, 1)
		end
		enemy_setObjectTimer(gameobject, 0.0)
	end
	
	if enemy_getObjectMode(gameobject) == 1 then -- dive bomb
		playerx, playery = game_getPlayerPos(game)
		velx = (playerx - x) * 0.75
		vely = (playery - y ) * 0.75

		if (math.abs(x - playerx) < 128.0 and math.abs(y - playery) < 64.0) or
			enemy_getObjectTimer(gameobject) > 2.0 then	
			enemy_setObjectMode(gameobject, 0)

			if velx < 0.0 then
				velx = -32.0
			elseif velx > 0.0 then
				velx = 32.0
			end

			vely = 256.0
		end

		enemy_setObjectVel(gameobject, velx, vely) 	
		enemy_setObjectTimer(gameobject, 0.0)	
	end

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

	if y > 320.0 and vely > 0.0 then
		vely = 0.0
	end

	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
	enemy_setObjectVel(gameobject, velx, vely) 
end

function enemy2.oncollision(gameobject, game)
	health = enemy_getObjectHealth(gameobject)
	health = health - 1
	enemy_setObjectHealth(gameobject, health)
	enemy_setObjectTimer(gameobject, 0.0)	

	-- if out of health, explode
	if health <= 0 then
		x, y = enemy_getObjectPos(gameobject)
		vis = game_getVisualEffectList(game)
		prefabs.addPrefab(vis, x, y, "explosion")
	end
	
	-- Delete object if health is less than or equal to 0
	return health <= 0
end

return enemy2
