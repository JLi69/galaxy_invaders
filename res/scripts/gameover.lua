local menuids = require("res.scripts.menuids")
local gameover = {}

function reset(game)
	-- reset enemies
	enemies = game_getEnemyList(game)
	
	-- clear all objects
	game_clearList(enemies)
	game_setWaveNum(game, 0)	
	bullets = game_getBulletList(game)
	game_clearList(bullets)
	visualEffects = game_getVisualEffectList(game)
	game_clearList(visualEffects)

	playerObject = game_getPlayer(game)
	player.start(playerObject)

	-- go to main menu
	gotomain(game)
end

function gameover.createmenu(game)	
	-- Title text
	menu_addTextToMenu(menuids.GAMEOVER, "Game Over!", 0.0, 128.0, 48.0)
	menu_setBackgroundColor(menuids.GAMEOVER, 255.0, 0.0, 0.0, 128.0)
	menu_showGameobjects(menuids.GAMEOVER, true)
	menu_addButtonToMenu(menuids.GAMEOVER, "Main Menu", "reset", 0.0, 0.0, 32.0)
end

return gameover
