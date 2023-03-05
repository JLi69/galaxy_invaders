-- This module is supposed to create templates for enemies
-- or other sprites in the game
local prefabs = {}

prefabs.prefablist = {}

-- example: prefab.newprefab("enemy", "res/images/enemy.png")
function prefabs.newprefab(name, luapath, mod, imagepath)
	prefab = {}
	prefab.mod = mod
	prefab.luapath = luapath
	prefab.imagepath = imagepath

	prefabs[name] = prefab
	prefabs.prefablist[#prefabs.prefablist + 1] = name
end

function prefabs.loadres()
	for i = 1, #prefabs.prefablist do
		game_loadScript(prefabs[prefabs.prefablist[i]].luapath, prefabs[prefabs.prefablist[i]].mod)
		game_loadTexture(prefabs[prefabs.prefablist[i]].imagepath)	
	end
end

function prefabs.init()
	prefabs.newprefab("player", "res/scripts/player.lua", "player", "res/images/spaceship.png")
	prefabs.newprefab("explosion", "res/scripts/explosion.lua", "explosion", "res/images/explosion.png")
	prefabs.newprefab("enemy", "res/scripts/enemy.lua", "enemy", "res/images/enemy1.png")
	prefabs.newprefab("bullet", "res/scripts/bullet.lua", "bullet", "res/images/bullet.png")
	
	prefabs.loadres()
end

function prefabs.addPrefab(gameobjectlist, x, y, sprite)
	game_addObject(gameobjectlist, x, y, prefabs[sprite].imagepath, prefabs[sprite].mod)
end

return prefabs
