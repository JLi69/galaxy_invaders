local menuids = require("res.scripts.menuids")
local pausemenu = {}

function unpause(game)
	game_setPaused(false)	
	menu_gotoMenu(game, menuids.GAME)	
end

function pausemenu.createmenu(game)	
	menu_addTextToMenu(menuids.PAUSED, "Paused", 0.0, 128.0, 64.0)
	menu_showGameobjects(menuids.PAUSED, true)
	menu_setBackgroundColor(menuids.PAUSED, 128.0, 128.0, 128.0, 128.0)
	menu_addButtonToMenu(menuids.PAUSED, "Return to Game", "unpause", 0.0, 0.0, 32.0)
	menu_addButtonToMenu(menuids.PAUSED, "Main Menu", "gotomain", 0.0, -64.0, 32.0)
end

return pausemenu
