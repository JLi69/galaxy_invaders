local menuids = require("res.scripts.menu.menuids")
local hiscore = require("res.scripts.menu.hiscore")
local waveselect = require("res.scripts.menu.waveselect")
local mainmenu = {}

-- These functions must be global
function quit(game)
	menu_gotoMenu(game, menuids.QUIT)
end

function play(game)
	if game_getWaveNum(game) > 0 then
		menu_gotoMenu(game, menuids.GAME)
		game_setPaused(false)
	else
		menu_gotoMenu(game, menuids.INTRO)
	end
end

function gotomain(game)
	-- Add visual effects
	local visualEffects = game_getVisualEffectList(game)		
	game_clearList(visualEffects)
	for i = 0, 80 do
		prefabs.addPrefab(visualEffects, 0, 300, "star") 		
	end

	menu_gotoMenu(game, menuids.MAIN)
end

function gotohiscore(game)
	menu_clear(menuids.HISCORE)
	menu_addTextToMenu(menuids.HISCORE, "High Scores", 0.0, 256.0, 48.0)
	menu_addButtonToMenu(menuids.HISCORE, "Main Menu", "gotomain", 0.0, -300.0, 32.0)

	hiscore.readscores("hiscore")
	hiscore.inOrder()
	local y = 200.0
	for i = 1, #hiscore.hiscores do
		local score = hiscore.hiscores[i]
		local str = "#" .. tostring(i) .. ": Score: " .. tostring(score.score) .. 
			  " Wave: " .. tostring(score.wave)
		menu_addTextToMenu(menuids.HISCORE, str, 0.0, y, 24.0)
		y = y - 32.0
		menu_addTextToMenu(menuids.HISCORE, "(" .. score.date .. ")", 0.0, y, 24.0)
		y = y - 64.0
	end

	menu_gotoMenu(game, menuids.HISCORE)
end

function credits(game)
	-- Initialize credits menu
	menu_clear(menuids.CREDITS)
	menu_addTextToMenu(menuids.CREDITS, "Credits", 0.0, 256.0, 48.0)
	
	-- Open file that contains the credits
	local y = 180.0

	file = io.open("res/CREDITS")
	if file then
		file:close()

		for line in io.lines("res/CREDITS") do
			menu_addTextToMenu(menuids.CREDITS, line, 0.0, y, 16.0)
			y = y - 32.0	
		end 
	end

	y = y - 32.0
	menu_addButtonToMenu(menuids.CREDITS, "Main Menu", "gotomain", 0.0, y, 32.0)

	menu_gotoMenu(game, menuids.CREDITS)
end

function gotoWaveSelect(game)	
	menu_clear(menuids.SELECT_WAVE)
	game_setWaveNum(game, 0)
	waveselect.createmenu(game)
	menu_gotoMenu(game, menuids.SELECT_WAVE)
end

function mainmenu.createmenu(game)
	-- Title text
	menu_addTextToMenu(menuids.MAIN, "Galaxy Invaders", 0.0, 128.0, 48.0)	
	
	menu_addTextToMenu(menuids.MAIN, "Lua Version: " .. _VERSION, -200.0, -320.0, 16.0)

	menu_addButtonToMenu(menuids.MAIN, "Play", "play", 0.0, 0.0, 32.0)
	menu_addButtonToMenu(menuids.MAIN, "Select Wave", "gotoWaveSelect", 0.0, -64.0, 32.0)
	menu_addButtonToMenu(menuids.MAIN, "High Scores", "gotohiscore", 0.0, -128.0, 32.0)
	menu_addButtonToMenu(menuids.MAIN, "Credits", "credits", 0.0, -192.0, 32.0)
	menu_addButtonToMenu(menuids.MAIN, "Quit", "quit", 0.0, -256.0, 32.0)
end

return mainmenu
