math = require("math")
local superweapon = {}

superweapon.targetX = 0
superweapon.targetY = 0

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

	if enemy_getObjectMode(gameobject) == 0 then	
		if timer > 0.3 then	
			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x - 36.0, y - 48.0, "enemy_bullet")
			prefabs.addPrefab(enemies, x + 36.0, y - 48.0, "enemy_bullet")
			enemy_setObjectTimer(gameobject, 0.0)
		end

		distToTarget = math.sqrt((superweapon.targetX - x) * (superweapon.targetX - x) + (superweapon.targetY - y) * (superweapon.targetY - y))
		if distToTarget < 16.0 then
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

	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
	enemy_setObjectVel(gameobject, velx, vely)
end

function superweapon.oncollision(gameobject, game)
	health = enemy_getObjectHealth(gameobject)
	health = health - 1
	enemy_setObjectHealth(gameobject, health)	

	-- if out of health, explode
	if health <= 0 then
		vis = game_getVisualEffectList(game)
		prefabs.addPrefab(vis, x, y, "explosion")
		x, y = enemy_getObjectPos(gameobject)
	end
	
	-- Delete object if health is less than or equal to 0
	return health <= 0
end

return superweapon
