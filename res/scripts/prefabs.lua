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

-- Create/add prefabs here
prefabs.newprefab("enemy", "res/scripts/enemy.lua", "enemy", "res/images/enemy1.png")

-- Load scripts/images
prefabs.loadres()

return prefabs
