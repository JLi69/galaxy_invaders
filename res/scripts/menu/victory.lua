local menuids = require("res.scripts.menu.menuids")
local victory = {}

function victory.createmenu()
	local text =
	{
		"You have defeated the Alpha Centuarian\'s superweapon!",
		"The Alpha Centauri fleet falls into chaos,",
		"Earth is able to mount a counterattack,",
		"The Alpha Centuarians retreat or surrender.",
		"Our galaxy is saved!",
		"You will forever be remembered as a hero.",
		"YOU WIN!"
	}

	local y = 128.0
	for i = 1, #text do
		menu_addTextToMenu(menuids.VICTORY, text[i], 0.0, y - i * 24.0, 16.0)	
	end

	menu_addButtonToMenu(menuids.VICTORY, "Activate Infinite Mode", "gotogame", 0.0, -200.0, 24.0) 
end

return victory 
