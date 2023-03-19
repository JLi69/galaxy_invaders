local menuids = require("res.scripts.menuids")
local introtext = {}

function gotogame(game)
	menu_gotoMenu(game, menuids.GAME)
end

function introtext.createmenu()
	local text =
	{
		"Earth is at war with the evil Alpha Centauri Empire",
		"and the space fleet has been all but destroyed.",
		"You are the last hope and now you must stop",
		"the Alpha Centaurians from invading our Galaxy.",
		"",
		"Arrow keys to move your spaceship, space to shoot,",
		"don't get blown up and good luck!"
	}

	local y = 128.0
	for i = 1, #text do
		menu_addTextToMenu(menuids.INTRO, text[i], 0.0, y - i * 24.0, 16.0)	
	end

	menu_addButtonToMenu(menuids.INTRO, "Cool, let's kill some aliens!", "gotogame", 0.0, -200.0, 24.0) 
end

return introtext
