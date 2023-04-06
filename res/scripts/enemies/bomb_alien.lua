math = require("math")
local bomb_alien = {}

bomb_alien.bullets = { "enemy_bullet", "star_bullet", "bomb", "bomb" }

function bomb_alien.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 64.0, 0.0)
	-- Set health
	enemy_setObjectHealth(gameobject, 2)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)
	enemy_setObjectFrameCount(gameobject, 4)

	enemy_setObjectScore(gameobject, 40)
end

function bomb_alien.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)	
	
	if enemy_getObjectMode(gameobject) == 1 then -- dive bomb
		playerx, playery = game_getPlayerPos(game)
		velx = (playerx - x) 
		vely = (playery - y) * 1.5 + 16.0

		if math.sqrt((x - playerx) * (x - playerx) + (y - playery) * (y - playery)) < 64.0 or
			enemy_getObjectTimer(gameobject) > 3.0 then	
			if math.random() < 0.2 and enemy_getObjectTimer(gameobject) < 3.0 then	
				enemy_setObjectMode(gameobject, 0)
				enemy_setObjectTimer(gameobject, -4.0) -- 6 second delay before the enemy could dive bomb again 

				enemies = game_getEnemyList(game)
				prefabs.addPrefab(enemies, x, y, "bomb")

				if velx < 0.0 then
					velx = -64.0 - math.random() * 64.0 + 32.0
				elseif velx > 0.0 then
					velx = 64.0 + math.random() * 64.0 - 32.0
				end

				vely = 256.0
			-- Explode	
			else
				enemies = game_getEnemyList(game)
				enemy_setObjectPos(gameobject, -9999.0, -9999.0)
				vis = game_getVisualEffectList(game)
				for i = 0, 4 do
					local angle = math.random() * 6.28
					local dist = math.random() * 32.0
					prefabs.addPrefab(vis, x + dist * math.cos(angle), y + dist * math.sin(angle), "explosion")
				end

				for i = 0, 15 do
					prefabs.addPrefab(enemies, x, y, "bomb_shard")
				end
				return
			end
		end

		enemy_setObjectVel(gameobject, velx, vely) 	
	end

	if timer > 2.0 and enemy_getObjectMode(gameobject) == 0 then	
		if math.random() < 0.05 then
			enemy_setObjectMode(gameobject, 1)
		elseif math.random() < 0.1 then
			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x, y, bomb_alien.bullets[math.floor(math.random() * #bomb_alien.bullets) + 1])
		end
		enemy_setObjectTimer(gameobject, 0.0)
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

	if y > 320.0 and vely > 0.0 then
		vely = 0.0
	end

	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
	enemy_setObjectVel(gameobject, velx, vely) 
	enemy_setObjectRotation(gameobject, enemy_getObjectRotation(gameobject) + 3.14159 * timepassed) 
end

function bomb_alien.oncollision(gameobject, game)
	health = enemy_getObjectHealth(gameobject)	
	health = health - 1
	enemy_setObjectHealth(gameobject, health)

	-- if out of health, explode
	if health <= 0 then
		x, y = enemy_getObjectPos(gameobject)
		vis = game_getVisualEffectList(game)
		for i = 0, 4 do
			local angle = math.random() * 6.28
			local dist = math.random() * 32.0
			prefabs.addPrefab(vis, x + dist * math.cos(angle), y + dist * math.sin(angle), "explosion")
		end
	end
	
	-- Delete object if health is less than or equal to 0
	return health <= 0
end

return bomb_alien
