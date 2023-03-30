math = require("math")
local eye_alien = {}

eye_alien.VEL = 256.0

function square_alien.getAngle(posX, posY, centerX, centerY)
	local diffX = posX - centerX
	local diffY = posY - centerY

	if diffX == 0 and diffY >= 0 then
		return 3.14159 / 2.0
	elseif diffX == 0 and diffY < 0 then
		return 3.14159 / 2.0 * 3.0
	end

	if diffX > 0 and diffY >= 0 then
		return math.atan(diffY / diffX)
	elseif diffX > 0 and diffY <= 0 then
		return math.atan(diffY / diffX) + 3.14159 * 2.0	
	elseif diffX < 0 and diffY >= 0 then
		return math.atan(diffY / diffX) + 3.14159
	elseif diffX < 0 and diffY <= 0 then
		return math.atan(diffY / diffX) + 3.14159
	end

	return 0.0
end

function eye_alien.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 32.0, 0.0)
	-- Set health
	enemy_setObjectHealth(gameobject, 4)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)
	enemy_setObjectFrameCount(gameobject, 4)

	enemy_setObjectScore(gameobject, 15)
end

function eye_alien.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)	
	
	if enemy_getObjectMode(gameobject) == 1 then -- dive bomb
		playerx, playery = game_getPlayerPos(game)

		velx = (playerx - x)
		vely = (playery - y) * 2
		
		-- Orbit around the player
		if math.sqrt((playerx - x) * (playerx - x) + (playery - y) * (playery - y)) < 128.0 then
			enemy_setObjectMode(gameobject, 2)
			return
		end

		if (enemy_getObjectTimer(gameobject) > 6.0 and y > playery + 32.0) or enemy_getObjectTimer(gameobject) > 12.0 then	
			
			if x > -320.0 or x < 320.0 then
				enemy_setObjectMode(gameobject, 3)
				return	
			else
				enemy_setObjectMode(gameobject, 0)
			end

			enemy_setObjectTimer(gameobject, -4.0) -- 6 second delay before the enemy could dive bomb again 

			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x, y, "purple_bullet")

			if velx < 0.0 then
				velx = -32.0 - math.random() * 32.0 + 16.0
			elseif velx > 0.0 then
				velx = 32.0 + math.random() * 32.0 - 16.0
			end

			vely = 256.0
		end

		enemy_setObjectVel(gameobject, velx, vely)
	elseif enemy_getObjectMode(gameobject) == 2 then
		velx = eye_alien.VEL * math.cos(square_alien.getAngle(x, y, playerx, playery) + 3.14159 / 2.0)
		vely = eye_alien.VEL * math.sin(square_alien.getAngle(x, y, playerx, playery) + 3.14159 / 2.0)

		if math.sqrt((playerx - x) * (playerx - x) + (playery - y) * (playery - y)) > 192.0 then	
			enemy_setObjectMode(gameobject, 1)
			return
		end

		if (enemy_getObjectTimer(gameobject) > 6.0 and y > playery + 32.0) or enemy_getObjectTimer(gameobject) > 12.0 then	
			if x > -320.0 or x < 320.0 then
				enemy_setObjectMode(gameobject, 3)
				return
			else
				enemy_setObjectMode(gameobject, 0)
			end

			enemy_setObjectTimer(gameobject, -4.0) -- 6 second delay before the enemy could dive bomb again 

			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x, y, "purple_bullet")

			if velx < 0.0 then
				velx = -32.0 - math.random() * 32.0 + 16.0
			elseif velx > 0.0 then
				velx = 32.0 + math.random() * 32.0 - 16.0
			end

			vely = 256.0
		end

		enemy_setObjectVel(gameobject, velx, vely)
	elseif enemy_getObjectMode(gameobject) == 3 then
		if x < 0.0 then
			velx = 128.0
			vely = 0.0
		elseif x > 0.0 then
			velx = -128.0
			vely = 0.0
		end

		if x > -280.0 and x < 280.0 then
			enemy_setObjectMode(gameobject, 0)

			enemy_setObjectTimer(gameobject, -4.0) -- 6 second delay before the enemy could dive bomb again 

			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x, y, "purple_bullet")

			if velx < 0.0 then
				velx = -32.0 - math.random() * 32.0 + 16.0
			elseif velx > 0.0 then
				velx = 32.0 + math.random() * 32.0 - 16.0
			end

			vely = 256.0
		end

		enemy_setObjectVel(gameobject, velx, vely)	
	end

	if timer > 2.0 and enemy_getObjectMode(gameobject) == 0 then	
		if math.random() < 0.1 then
			enemy_setObjectMode(gameobject, 1)
		elseif math.random() < 0.1 then
			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x, y, "purple_bullet")
		end
		enemy_setObjectTimer(gameobject, 0.0)
	end

	-- Bounce off of edges of screen
	if x < -320.0 and enemy_getObjectMode(gameobject) == 0 then	
		enemy_setObjectVel(gameobject, -velx, vely)
		enemy_setObjectPos(gameobject, -320.0, y)
	elseif x > 320.0 and enemy_getObjectMode(gameobject) == 0 then	
		enemy_setObjectVel(gameobject, -velx, vely)	
		enemy_setObjectPos(gameobject, 320.0, y)
	end

	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	if y > 320.0 and enemy_getObjectMode(gameobject) == 0 then
		vely = -32.0
	elseif y > 280.0 and enemy_getObjectMode(gameobject) == 0 then
		vely = 0.0
	end

	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
	enemy_setObjectVel(gameobject, velx, vely) 
end

function eye_alien.oncollision(gameobject, game)
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

return eye_alien
