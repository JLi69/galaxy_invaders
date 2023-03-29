math = require("math")
local square_alien = {}

square_alien.CENTERX = 0
square_alien.CENTERY = 150
square_alien.VEL = 32

function square_alien.getAngle(posX, posY)
	local diffX = posX - square_alien.CENTERX
	local diffY = posY - square_alien.CENTERY

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

-- run this upon enemy start
function square_alien.start(gameobject)
	-- Set object's velocity
	enemy_setObjectVel(gameobject, 0.0, 0.0)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)	
	enemy_setObjectFrameCount(gameobject, 4)
	enemy_setObjectHealth(gameobject, 3)
	enemy_setObjectScore(gameobject, 10)
end

function square_alien.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	rotation = enemy_getObjectRotation(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer + timepassed)

	if timer >= 1.0 then
		-- shoot
		if math.random() < 0.1 then
			enemies = game_getEnemyList(game)
			for i = 0, 2 do
				prefabs.addPrefab(enemies, x, y + i * 16.0, "enemy_bullet")	
			end	
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

	local dist2 = (x - square_alien.CENTERX) * (x - square_alien.CENTERX) + (y - square_alien.CENTERY) * (y - square_alien.CENTERY)
	if dist2 > 300.0 * 300.0 then
		enemy_setObjectMode(gameobject, 1)
	elseif dist2 < 32.0 * 32.0 then
		enemy_setObjectMode(gameobject, 0)
	end

	if enemy_getObjectMode(gameobject) == 0 then 
		enemy_setObjectVel(gameobject, square_alien.VEL * math.cos(square_alien.getAngle(x, y) - 3.14159 / 2.0) + 
									   square_alien.VEL * 2.0 * math.cos(square_alien.getAngle(x, y)), 
									   square_alien.VEL * math.sin(square_alien.getAngle(x, y) - 3.14159 / 2.0) + 
									   square_alien.VEL * 2.0 * math.sin(square_alien.getAngle(x, y)))
	elseif enemy_getObjectMode(gameobject) == 1 then
		enemy_setObjectVel(gameobject, square_alien.VEL * math.cos(square_alien.getAngle(x, y) - 3.14159 / 2.0) + 
									   -square_alien.VEL * 2.0 * math.cos(square_alien.getAngle(x, y)), 
									   square_alien.VEL * math.sin(square_alien.getAngle(x, y) - 3.14159 / 2.0) + 
									   -square_alien.VEL * 2.0 * math.sin(square_alien.getAngle(x, y)))
	end

	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)
	-- move the object
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
	enemy_setObjectRotation(gameobject, -square_alien.getAngle(x, y)) 
end

-- run this when the enemy collides with a bullet
-- returns a value true or false,
-- if the value is true, then delete the enemy,
-- if the value is false, then do not delete the enemy
function square_alien.oncollision(gameobject, game)		
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

return square_alien
