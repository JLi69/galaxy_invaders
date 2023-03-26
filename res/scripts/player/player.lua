local menuids = require("res.scripts.menu.menuids")
local gameover = require("res.scripts.menu.gameover")
local player = {}

player.SHOOT_COOLDOWN = 0.7 
player.INVINCIBLE_TIMER = 3.0
player.WAVES_FOR_ONE_UP = 4

local SPAWN_X = 0
local SPAWN_Y = -300

function player.start(gameobject)
	enemy_setObjectMode(gameobject, 0)
	enemy_setObjectHealth(gameobject, 3)
	enemy_setObjectPos(gameobject, SPAWN_X, SPAWN_Y)
	enemy_setObjectPicture(gameobject, "res/images/spaceship.png")
	enemy_setObjectScore(gameobject, 0)
end

function player.update(gameobject, game, timepassed)
	if enemy_getObjectHealth(gameobject) <= 0 and menu_getMenuId(game) == menuids.GAME then	
		gameover.createmenu(game)
		menu_gotoMenu(game, menuids.GAMEOVER)
	end

	-- Player is dead	
	if enemy_getObjectMode(gameobject) == 1 then
		if enemy_getObjectFrame(gameobject) == enemy_getObjectFrameCount(gameobject) - 1 then
			
			if enemy_getObjectHealth(gameobject) > 0 then
				enemy_setObjectMode(gameobject, 2)
				enemy_setObjectPicture(gameobject, "res/images/shielded_spaceship.png")
				enemy_setObjectTimer(gameobject, player.INVINCIBLE_TIMER)
			else
				enemy_setObjectPicture(gameobject, nil)
			end

			enemy_setObjectPos(gameobject, SPAWN_X, SPAWN_Y)
		end	
		return
	end	

	x, y = enemy_getObjectPos(gameobject)
	velx, vely = enemy_getObjectVel(gameobject)

	timer = enemy_getObjectTimer(gameobject)
	enemy_setObjectTimer(gameobject, timer - timepassed)	

	-- Bound the player's position
	if x < -360.0 then
		x = -360.0
		enemy_setObjectPos(gameobject, x, y)
	elseif x > 360.0 then
		x = 360.0
		enemy_setObjectPos(gameobject, x, y)
	end

	if y < -320.0 then
		y = -320.0
		enemy_setObjectPos(gameobject, x, y)
	elseif y > 320.0 then
		y = 320.0
		enemy_setObjectPos(gameobject, x, y)
	end

	-- move the player
	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)

	-- Invincibility 
	if enemy_getObjectMode(gameobject) == 2 and enemy_getObjectTimer(gameobject) <= 0.0 then
		enemy_setObjectMode(gameobject, 0)
		enemy_setObjectPicture(gameobject, "res/images/spaceship.png")
	end
	
	-- Make the player invincible if the wave is gone for 1 second
	local enemies = game_getEnemyList(game)
	if game_sizeofList(enemies) == 0 and game_getWaveNum(game) ~= 0 then
		enemy_setObjectMode(gameobject, 2)
		enemy_setObjectPicture(gameobject, "res/images/shielded_spaceship.png")
		enemy_setObjectTimer(gameobject, 1.5)

		-- 1 UP
		local health = enemy_getObjectHealth(gameobject)
		if game_getWaveNum(game) % player.WAVES_FOR_ONE_UP == 0 and health < 4 then
			health = health + 1
			enemy_setObjectHealth(gameobject, health)
		end
	end
end

function player.oncollision(gameobject, game)
	if enemy_getObjectMode(gameobject) == 0 then
		local health = enemy_getObjectHealth(gameobject)
		health = health - 1
		enemy_setObjectHealth(gameobject, health)
		enemy_setObjectMode(gameobject, 1)
		enemy_setObjectFrame(gameobject, 0)	
		enemy_setObjectPicture(gameobject, "res/images/explosion.png")
	end

	return false
end

return player
