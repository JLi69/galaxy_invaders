local menuids = require("res.scripts.menu.menuids")
local boss_intro = {}

function boss_intro.createmenu()
	local text =
	{
		"You have done a good job defending Earth,",
		"However, we have received a critical intelligence",
		"report that the Alpha Centaurians are planning a",
		"massive attack on Earth and they have a superweapon",
		"That could destroy the remaining Solar System defense.",
		"However, if you destroy this superweapon,",
		"we might still have a chance at winning this war."
	}

	local y = 128.0
	for i = 1, #text do
		menu_addTextToMenu(menuids.BOSS_FIGHT_INTRO, text[i], 0.0, y - i * 24.0, 16.0)	
	end

	menu_addButtonToMenu(menuids.BOSS_FIGHT_INTRO, "Report to battle stations!", "gotogame", 0.0, -200.0, 24.0) 
end

return boss_intro 
