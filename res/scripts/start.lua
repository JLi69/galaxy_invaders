local mainmenu = require("res.scripts.menu.mainmenu")
local pausemenu = require("res.scripts.menu.pausemenu")
local gameoverscreen = require("res.scripts.menu.gameover")
local introtext = require("res.scripts.menu.intro")
local boss_intro = require("res.scripts.menu.boss_intro")

-- This function is called once at the beginning of the game
function startgame(game)
	mainmenu.createmenu(game)
	pausemenu.createmenu(game)
	introtext.createmenu(game)
	boss_intro.createmenu()

	-- Add visual effects
	local visualEffects = game_getVisualEffectList(game)		
	for i = 0, 80 do
		prefabs.addPrefab(visualEffects, 0, 300, "star") 		
	end
end
