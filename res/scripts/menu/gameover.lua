local menuids = require("res.scripts.menu.menuids")
local hiscore = require("res.scripts.menu.hiscore")
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
	game_setTimer(game, 0)

	playerObject = game_getPlayer(game)
	player.start(playerObject)

	-- go to main menu
	gotomain(game)
end

function gameover.createmenu(game)	
	menu_clear(menuids.GAMEOVER)
	local playerObj = game_getPlayer(game)
	local score = enemy_getObjectScore(playerObj)
	local waveNum = game_getWaveNum(game)

	-- Title text
	menu_addTextToMenu(menuids.GAMEOVER, "Game Over!", 0.0, 160.0, 48.0)

	-- Timer
	timer = game_getTimer(game)
	minutes = math.floor(timer / 60)
	seconds = math.floor(timer - minutes * 60)

	-- Final score and wave counter for the player	
	-- tell player if they got a new high score
	hiscore.readscores("hiscore")

	-- Attempt to save new hiscore
	newHighScore = {}
	newHighScore.score = score
	newHighScore.wave = waveNum
	newHighScore.date = os.date()
	
	if hiscore.checkForNewHigh(newHighScore) then	
		menu_addTextToMenu(menuids.GAMEOVER, "new high score!", 0.0, 110.0, 16.0)	

		hiscore.tryToAddHigh(newHighScore)
		hiscore.inOrder()
		hiscore.saveHighScores("hiscore")
	end

	menu_addTextToMenu(menuids.GAMEOVER, "Final Score: " .. tostring(score), 0.0, 80.0, 24.0)
	if seconds >= 10 then
		menu_addTextToMenu(menuids.GAMEOVER, "Time Played: " .. tostring(minutes) .. ":" .. tostring(seconds), 0.0, 44.0, 24.0) 
	else 
		menu_addTextToMenu(menuids.GAMEOVER, "Time Played: " .. tostring(minutes) .. ":0" .. tostring(seconds), 0.0, 44.0, 24.0) 
	end

	menu_addTextToMenu(menuids.GAMEOVER, "On Wave: " .. tostring(waveNum), 0.0, 8.0, 24.0)
	menu_setBackgroundColor(menuids.GAMEOVER, 255.0, 0.0, 0.0, 128.0)
	menu_showGameobjects(menuids.GAMEOVER, true)
	menu_addButtonToMenu(menuids.GAMEOVER, "Main Menu", "reset", 0.0, -80.0, 32.0)
end

return gameover
