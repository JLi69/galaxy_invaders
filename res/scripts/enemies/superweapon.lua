math = require("math")
local superweapon = {}

superweapon.targetX = 0
superweapon.targetY = 0
superweapon.images = { "res/images/superweapon-phase2.png", "res/images/superweapon-phase3.png", "res/images/superweapon-phase4.png" }

function superweapon.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 0.0, 0.0)
	-- Set health
	enemy_setObjectHealth(gameobject, 32)		
	enemy_setObjectSize(gameobject, SPRITE_SIZE * 3.0, SPRITE_SIZE * 3.0)
	enemy_setObjectFrameCount(gameobject, 4)

	superweapon.targetX = math.random() * 640.0 - 320.0
	superweapon.targetY = math.random() * 400.0 - 100.0

	enemy_setObjectScore(gameobject, 1000)
end

function superweapon.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)	

	if enemy_getObjectMode(gameobject) == -1 then
		if enemy_getObjectTimer(gameobject) > 1.5 then
			enemy_setObjectMode(gameobject, 0)
			enemy_setObjectTimer(gameobject, 0.0)	
		end
		return
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

	health = enemy_getObjectHealth(gameobject)

	if health == 0 then
		return
	end

	if health > 24 then
		if enemy_getObjectMode(gameobject) == 0 then	
			if timer > 0.3 then	
				enemies = game_getEnemyList(game)
				prefabs.addPrefab(enemies, x - 36.0, y - 48.0, "enemy_bullet")
				prefabs.addPrefab(enemies, x + 36.0, y - 48.0, "enemy_bullet")
				enemy_setObjectTimer(gameobject, 0.0)
			end

			distToTarget = math.sqrt((superweapon.targetX - x) * (superweapon.targetX - x) + (superweapon.targetY - y) * (superweapon.targetY - y))
			if distToTarget < 16.0 then
				enemies = game_getEnemyList(game)
				prefabs.addPrefab(enemies, x, y - 48.0, "bomb")
				superweapon.targetX = math.random() * 640.0 - 320.0
				superweapon.targetY = math.random() * 400.0 - 100.0
				if math.random() < 0.5 then
					velx = 160.0
				else
					velx = -160.0
				end
				vely = 0
				enemy_setObjectMode(gameobject, 1)	
				enemy_setObjectTimer(gameobject, 0)
			else
				velx = (superweapon.targetX - x) / distToTarget * 128.0
				vely = (superweapon.targetY - y) / distToTarget * 128.0
			end	 
		elseif enemy_getObjectMode(gameobject) == 1 then
			if enemy_getObjectTimer(gameobject) >= 3.0 then
				prefabs.addPrefab(enemies, x, y - 48.0, "bomb")
				enemy_setObjectMode(gameobject, 0)
			end
		end
	elseif health > 16 then
		if enemy_getObjectMode(gameobject) == 0 then	
			if timer > 0.5 then	
				enemies = game_getEnemyList(game)
				prefabs.addPrefab(enemies, x, y - 48.0 - 16.0, "bomb")
				prefabs.addPrefab(enemies, x - 8.0, y - 48.0, "bomb")
				prefabs.addPrefab(enemies, x + 8.0, y - 48.0, "bomb")
				enemy_setObjectTimer(gameobject, 0.0)
			end

			distToTarget = math.sqrt((superweapon.targetX - x) * (superweapon.targetX - x) + (superweapon.targetY - y) * (superweapon.targetY - y))
			if distToTarget < 16.0 then
				prefabs.addPrefab(enemies, x - 36.0, y - 48.0, "laser")
				prefabs.addPrefab(enemies, x + 36.0, y - 48.0, "laser")
				superweapon.targetX = math.random() * 640.0 - 320.0
				superweapon.targetY = math.random() * 400.0 - 100.0
				enemy_setObjectMode(gameobject, 1)	
				enemy_setObjectTimer(gameobject, 0)
			else
				velx = (superweapon.targetX - x) / distToTarget * 128.0
				vely = (superweapon.targetY - y) / distToTarget * 128.0
			end	 
		elseif enemy_getObjectMode(gameobject) == 1 then
			velx = 0.0
			vely = 0.0

			if timer > 3.5 then
				enemy_setObjectMode(gameobject, 0)
			end
		end
	elseif health > 8 then
		if enemy_getObjectMode(gameobject) == 0 then	
			if timer > 0.5 then	
				enemies = game_getEnemyList(game)
				prefabs.addPrefab(enemies, x - 36.0, y - 48.0, "pink_bullet")
				prefabs.addPrefab(enemies, x + 36.0, y - 48.0, "pink_bullet")
				enemy_setObjectTimer(gameobject, 0.0)
			end

			distToTarget = math.sqrt((superweapon.targetX - x) * (superweapon.targetX - x) + (superweapon.targetY - y) * (superweapon.targetY - y))
			if distToTarget < 16.0 then
				enemies = game_getEnemyList(game)
				superweapon.targetX = math.random() * 640.0 - 320.0
				superweapon.targetY = math.random() * 400.0 - 100.0
				enemy_setObjectMode(gameobject, 1)	
				enemy_setObjectTimer(gameobject, 0)

				prefabs.addPrefab(enemies, x - 36.0, y - 48.0, "laser")	
				prefabs.addPrefab(enemies, x, y - 48.0, "laser")
				prefabs.addPrefab(enemies, x + 36.0, y - 48.0, "laser")
			else
				velx = (superweapon.targetX - x) / distToTarget * 128.0
				vely = (superweapon.targetY - y) / distToTarget * 128.0
			end	 
		elseif enemy_getObjectMode(gameobject) == 1 then
			velx = 0.0
			vely = 0.0
			if timer > 1.5 then
				enemy_setObjectMode(gameobject, 2)
				enemy_setObjectTimer(gameobject, 0.0)
			end
		elseif enemy_getObjectMode(gameobject) == 2 then	
			playerx, playery = game_getPlayerPos(game)	
			if x < playerx - 16 then		
				velx = 240.0
			elseif x > playerx + 16 then
				velx = -240.0
			else
				velx = 0.0
			end
			vely = 0.0

			if timer > 4.5 or velx == 0.0 or x >= 320.0 or x <= -320.0 then
				enemy_setObjectTimer(gameobject, 0.0)
				enemy_setObjectMode(gameobject, 3)
				for i = 0, 8 do
					prefabs.addPrefab(enemies, x, y - 48.0, "star_bullet")
				end		
			end
		elseif enemy_getObjectMode(gameobject) == 3 then
			if timer > 2.0 then
				enemy_setObjectTimer(gameobject, 0.0)
				enemy_setObjectMode(gameobject, 0)
			end
		end
	else
		if enemy_getObjectMode(gameobject) == 0 then	
			if timer > 0.07 then	
				enemies = game_getEnemyList(game)
				prefabs.addPrefab(enemies, x - 36.0, y - 48.0, "enemy_bullet")
				prefabs.addPrefab(enemies, x + 36.0, y - 48.0, "enemy_bullet")
				enemy_setObjectTimer(gameobject, 0.0)
			end

			distToTarget = math.sqrt((superweapon.targetX - x) * (superweapon.targetX - x) + (superweapon.targetY - y) * (superweapon.targetY - y))
			if distToTarget < 16.0 then
				enemies = game_getEnemyList(game)
				superweapon.targetX = math.random() * 560.0 - 280.0
				superweapon.targetY = math.random() * 400.0 - 100.0
				enemy_setObjectMode(gameobject, 1)	
				enemy_setObjectTimer(gameobject, 0)
				
				if math.random() < 0.5 then
					prefabs.addPrefab(enemies, x, y - 80.0, "bomb_alien")
				elseif math.random() < 0.5 then
					for i = -3, 3 do
						prefabs.addPrefab(enemies, x + i * 16.0, y - 48.0, "purple_bullet")
					end
				else
					for i = -3, 3 do
						prefabs.addPrefab(enemies, x + i * 16.0, y - 48.0, "bomb")
					end
				end
			else
				velx = (superweapon.targetX - x) / distToTarget * 128.0
				vely = (superweapon.targetY - y) / distToTarget * 128.0
			end	 
		elseif enemy_getObjectMode(gameobject) == 1 then
			velx = 0.0
			vely = 0.0
			if timer > 2.5 then
				enemy_setObjectMode(gameobject, 0)
				enemy_setObjectTimer(gameobject, 0.0)	
			
				if math.random() < 0.2 then
					for i = 0, 5 do
						prefabs.addPrefab(enemies, x + 80.0 * math.cos(6.28 / 6 * i), y + 80.0 * math.sin(6.28 / 6 * i), "enemy")
					end	
				end
			end
		end
	end

	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
	enemy_setObjectVel(gameobject, velx, vely)
end

function superweapon.oncollision(gameobject, game)
	health = enemy_getObjectHealth(gameobject)

	if enemy_getObjectMode(gameobject) < 0 then
		return
	end
	
	if health <= 0 then
		return false
	end

	health = health - 1
	enemy_setObjectHealth(gameobject, health)	

	if health == 24 or health == 16 or health == 8 then
		local ind = 4 - health / 8	
		enemy_setObjectPicture(gameobject, superweapon.images[ind])
		
		vis = game_getVisualEffectList(game)
		x, y = enemy_getObjectPos(gameobject)
		for i = 0, 8 do
			local angle = math.random() * 6.28
			local dist = math.random() * 80.0
			prefabs.addPrefab(vis, x + dist * math.cos(angle), y + dist * math.sin(angle), "explosion")
		end

		enemy_setObjectVel(gameobject, 0.0, 0.0)
		enemy_setObjectMode(gameobject, -1)
		enemy_setObjectTimer(gameobject, 0.0)
	end

	-- if out of health, explode
	if health <= 0 then
		vis = game_getVisualEffectList(game)
		x, y = enemy_getObjectPos(gameobject)	
		for i = 0, 32 do
			local angle = math.random() * 6.28
			local dist = math.random() * 40.0
			prefabs.addPrefab(vis, x + dist * math.cos(angle), y + dist * math.sin(angle), "explosion")
		end
		enemies = game_getEnemyList(game)
		game_clearList(enemies)
		for i = 0, 64 do
			prefabs.addPrefab(enemies, x, y, "bomb_shard")
		end
		enemy_setObjectPicture(gameobject, nil)
		return true	
	end
	
	return false
end

return superweapon
