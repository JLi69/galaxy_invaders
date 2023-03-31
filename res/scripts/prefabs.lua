-- This module is supposed to create templates for enemies
-- or other sprites in the game
local prefabs = {}

prefabs.prefablist = {}

-- example: prefab.newprefab("enemy", "res/scripts/enemy.lua", "enemy", "res/images/enemy.png")
function prefabs.newprefab(name, luapath, mod, imagepath)
	prefab = {}
	prefab.mod = mod
	prefab.luapath = luapath
	prefab.imagepath = imagepath

	prefabs[name] = prefab
	prefabs.prefablist[#prefabs.prefablist + 1] = name
end

-- example: prefab.prefab("enemy", "res/scripts/enemy.lua", "res/images/enemy.png")
-- basically just prefabs.newprefab but mod is assumed to be the same as name
function prefabs.prefab(name, luapath, imagepath)
	prefabs.newprefab(name, luapath, name, imagepath)
end

function prefabs.loadres()
	for i = 1, #prefabs.prefablist do
		game_loadScript(prefabs[prefabs.prefablist[i]].luapath, prefabs[prefabs.prefablist[i]].mod)
		game_loadTexture(prefabs[prefabs.prefablist[i]].imagepath)	
	end
end

function prefabs.init()
	prefabs.prefab("player", "res/scripts/player/player.lua", "res/images/spaceship.png")
	prefabs.prefab("bullet", "res/scripts/player/bullet.lua", "res/images/bullet.png")

	prefabs.prefab("explosion", "res/scripts/visual_effects/explosion.lua", "res/images/explosion.png")		
	prefabs.prefab("star", "res/scripts/visual_effects/star.lua", "res/images/star.png")
	
	prefabs.prefab("enemy", "res/scripts/enemies/enemy.lua", "res/images/enemy1.png")		
	prefabs.prefab("enemy2", "res/scripts/enemies/enemy2.lua", "res/images/enemy2.png")
	prefabs.prefab("enemy3", "res/scripts/enemies/enemy3.lua", "res/images/enemy3.png")
	prefabs.prefab("circle_alien", "res/scripts/enemies/circle_alien.lua", "res/images/circle_alien.png")
	prefabs.prefab("square_alien", "res/scripts/enemies/square_alien.lua", "res/images/square_alien.png")
	prefabs.prefab("star_alien", "res/scripts/enemies/star_alien.lua", "res/images/star_alien.png")
	prefabs.prefab("shielded_alien", "res/scripts/enemies/shielded_alien.lua", "res/images/shielded_alien.png")
	prefabs.prefab("ufo", "res/scripts/enemies/ufo.lua", "res/images/ufo.png")
	prefabs.prefab("eye_alien", "res/scripts/enemies/eye_alien.lua", "res/images/eye_alien.png")
	prefabs.prefab("bomb_alien", "res/scripts/enemies/bomb_alien.lua", "res/images/bomb_alien.png")
	prefabs.prefab("slime_alien", "res/scripts/enemies/slime_alien.lua", "res/images/slime_alien.png")

	prefabs.prefab("enemy_bullet", "res/scripts/bullets/enemy_bullet.lua", "res/images/enemy_bullet.png")
	prefabs.prefab("pink_bullet", "res/scripts/bullets/pink_bullet.lua", "res/images/pink_bullet.png")
	prefabs.prefab("purple_bullet", "res/scripts/bullets/purple_bullet.lua", "res/images/purple_bullet.png")
	prefabs.prefab("star_bullet", "res/scripts/bullets/star_bullet.lua", "res/images/star_bullet.png")
	prefabs.prefab("bomb", "res/scripts/bullets/bomb.lua", "res/images/bomb.png")
	prefabs.prefab("bomb_shard", "res/scripts/bullets/bomb_shard.lua", "res/images/bomb_shard.png")
	prefabs.prefab("laser", "res/scripts/bullets/laser.lua", "res/images/laser.png")
	
	prefabs.loadres()

	game_loadTexture("res/images/shielded_spaceship.png")	
end

function prefabs.addPrefab(gameobjectlist, x, y, sprite)
	game_addObject(gameobjectlist, x, y, prefabs[sprite].imagepath, prefabs[sprite].mod)
end

return prefabs
