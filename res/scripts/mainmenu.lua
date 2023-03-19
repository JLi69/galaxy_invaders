local menuids = require("res.scripts.menuids")
local mainmenu = {}

-- These functions must be global
function quit(game)
	menu_gotoMenu(game, menuids.QUIT)
end

function play(game)
	menu_gotoMenu(game, menuids.GAME)
	game_setPaused(false)
end

function gotomain(game)
	menu_gotoMenu(game, menuids.MAIN)
end

function gotohiscore(game)
	menu_clear(menuids.HISCORE)
	menu_addTextToMenu(menuids.HISCORE, "TBA", 0.0, 128.0, 48.0)
	menu_addButtonToMenu(menuids.HISCORE, "Main Menu", "gotomain", 0.0, -300.0, 32.0)
	menu_gotoMenu(game, menuids.HISCORE)
end

function credits(game)
	-- Initialize credits menu
	menu_clear(menuids.CREDITS)
	menu_addTextToMenu(menuids.CREDITS, "Credits", 0.0, 256.0, 48.0)
	
	-- Open file that contains the credits
	y = 180.0
	for line in io.lines("res/CREDITS") do
		menu_addTextToMenu(menuids.CREDITS, line, 0.0, y, 16.0)
		y = y - 32.0	
	end 

	y = y - 32.0
	menu_addButtonToMenu(menuids.CREDITS, "Main Menu", "gotomain", 0.0, y, 32.0)

	menu_gotoMenu(game, menuids.CREDITS)
end

function mainmenu.createmenu(game)
	-- Title text
	menu_addTextToMenu(menuids.MAIN, "Galaxy Invaders", 0.0, 128.0, 48.0)	
	menu_addTextToMenu(menuids.MAIN, "(demo version)", 0.0, 80.0, 16.0)
	menu_addButtonToMenu(menuids.MAIN, "Play", "play", 0.0, 0.0, 32.0)
	menu_addButtonToMenu(menuids.MAIN, "High Scores", "gotohiscore", 0.0, -64.0, 32.0)
	menu_addButtonToMenu(menuids.MAIN, "Credits", "credits", 0.0, -128.0, 32.0)
	menu_addButtonToMenu(menuids.MAIN, "Quit", "quit", 0.0, -192.0, 32.0)
end

return mainmenu
