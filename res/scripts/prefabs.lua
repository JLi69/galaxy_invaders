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
	prefabs.prefab("player", "res/scripts/player.lua", "res/images/spaceship.png")
	prefabs.prefab("explosion", "res/scripts/explosion.lua", "res/images/explosion.png")	
	prefabs.prefab("enemy", "res/scripts/enemy.lua", "res/images/enemy1.png")		
	prefabs.prefab("enemy2", "res/scripts/enemy2.lua", "res/images/enemy2.png")
	prefabs.prefab("bullet", "res/scripts/bullet.lua", "res/images/bullet.png")
	prefabs.prefab("star", "res/scripts/star.lua", "res/images/star.png")
	prefabs.prefab("enemy_bullet", "res/scripts/enemy_bullet.lua", "res/images/enemy_bullet.png")
	prefabs.prefab("pink_bullet", "res/scripts/pink_bullet.lua", "res/images/pink_bullet.png")

	prefabs.loadres()
end

function prefabs.addPrefab(gameobjectlist, x, y, sprite)
	game_addObject(gameobjectlist, x, y, prefabs[sprite].imagepath, prefabs[sprite].mod)
end

return prefabs
