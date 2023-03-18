local createmenu = {}

createmenu.QUIT = -2
createmenu.GAME = -1
createmenu.MAIN = 0

function quit(game)
	menu_gotoMenu(game, createmenu.QUIT)
end

function play(game)
	menu_gotoMenu(game, createmenu.GAME)
	game_setPaused(false)
end

function createmenu.createmainmenu(game)
	menu_addTextToMenu(createmenu.MAIN, "Galaxy Invaders", 0.0, 128.0, 48.0)
	menu_addButtonToMenu(createmenu.MAIN, "Play", "play", 0.0, 0.0, 32.0)
	menu_addButtonToMenu(createmenu.MAIN, "High Scores", "foo", 0.0, -64.0, 32.0)
	menu_addButtonToMenu(createmenu.MAIN, "Quit", "quit", 0.0, -128.0, 32.0)
end

return createmenu
