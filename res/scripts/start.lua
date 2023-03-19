local mainmenu = require("res.scripts.mainmenu")

-- This function is called once at the beginning of the game
function startgame(game)
	mainmenu.createmenu(game)

	-- Add visual effects
	visualEffects = game_getVisualEffectList(game)		
	for i = 0, 80 do
		prefabs.addPrefab(visualEffects, 0, 300, "star") 		
	end
end
