local mainmenu = require("res.scripts.mainmenu")
local pausemenu = require("res.scripts.pausemenu")
local gameoverscreen = require("res.scripts.gameover")
local introtext = require("res.scripts.intro")

-- This function is called once at the beginning of the game
function startgame(game)
	mainmenu.createmenu(game)
	pausemenu.createmenu(game)
	gameoverscreen.createmenu(game)
	introtext.createmenu(game)

	-- Add visual effects
	local visualEffects = game_getVisualEffectList(game)		
	for i = 0, 80 do
		prefabs.addPrefab(visualEffects, 0, 300, "star") 		
	end
end
