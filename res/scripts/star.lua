math = require("math")
local star = {}

function star.start(gameobject)
	enemy_setObjectSize(gameobject, 16, 16)
	enemy_setObjectFrame(gameobject, 0)
	enemy_setObjectFrameCount(gameobject, 4)
	enemy_setObjectVel(gameobject, 0, -16)
	enemy_setObjectPos(gameobject, math.random() * 1920 - 960, math.random() * 1080 - 540)
	enemy_setObjectZ(gameobject, -1)
end

function star.update(gameobject, game, timepassed)
	-- Get object's position
	x, y = enemy_getObjectPos(gameobject)
	-- Get velocity
	velx, vely = enemy_getObjectVel(gameobject)

	enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)
	
	-- Reset the frame
	enemy_setObjectFrame(gameobject, 0)	

	-- Off the screen, reset position
	if y < -540 then		
		enemy_setObjectPos(gameobject, math.random() * 1920 - 960, math.random() * 40 + 560)
	end
end

function star.oncollision(gameobject, game)
	return false
end

return star
