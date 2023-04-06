local menuids = require("res.scripts.menu.menuids")
local victory = {}

function victory.createmenu(game)
	menu_clear(menuids.VICTORY)

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

	-- Timer
	timer = game_getTimer(game)
	minutes = math.floor(timer / 60)
	seconds = math.floor(timer - minutes * 60)

	if seconds >= 10 then
		menu_addTextToMenu(menuids.VICTORY, "Time: " .. tostring(minutes) .. ":" .. tostring(seconds), 0.0, -80, 32.0)	
	else
		menu_addTextToMenu(menuids.VICTORY, "Time: " .. tostring(minutes) .. ":0" .. tostring(seconds), 0.0, -80, 32.0)	
	end

	menu_addButtonToMenu(menuids.VICTORY, "Activate Infinite Mode", "gotogame", 0.0, -200.0, 24.0) 
end

return victory 
