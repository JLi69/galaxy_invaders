math = require("math")
local shielded_alien = {}

function shielded_alien.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 32.0, 0.0)
	-- Set health
	enemy_setObjectHealth(gameobject, 4)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)
	enemy_setObjectFrameCount(gameobject, 4)

	enemy_setObjectScore(gameobject, 35)
end

function shielded_alien.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)		

	if timer > 2.0 and enemy_getObjectMode(gameobject) == 0 then	
		if math.random() < 0.1 then
			enemies = game_getEnemyList(game)
			prefabs.addPrefab(enemies, x, y, "bomb")
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
end

function shielded_alien.oncollision(gameobject, game)
	health = enemy_getObjectHealth(gameobject)
	health = health - 1
	enemy_setObjectHealth(gameobject, health)

	-- if out of health, explode
	if health <= 0 then
		x, y = enemy_getObjectPos(gameobject)
		vis = game_getVisualEffectList(game)
		prefabs.addPrefab(vis, x, y, "explosion")
	elseif health == 1 then	
		-- Shields down!
		enemy_setObjectPicture(gameobject, "res/images/enemy1.png")
	end
	
	-- Delete object if health is less than or equal to 0
	return health <= 0
end

return shielded_alien
