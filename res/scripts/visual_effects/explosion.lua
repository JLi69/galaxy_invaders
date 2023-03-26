local explosion = {}

-- run this upon enemy start
function explosion.start(gameobject)
	enemy_setObjectSize(gameobject, SPRITE_SIZE, SPRITE_SIZE)
	enemy_setObjectFrameCount(gameobject, 4)
end

function explosion.update(gameobject, game, timepassed) end

function explosion.oncollision(gameobject, game)	
	return false
end

return explosion
