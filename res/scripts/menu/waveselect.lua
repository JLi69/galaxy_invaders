local menuids = require("res.scripts.menu.menuids")
local waveselect = {}

function waveselect.refresh(game)	
	menu_clear(menuids.SELECT_WAVE)
	waveselect.createmenu(game)
end

function nextwave(game)	
	local waveNum = game_getWaveNum(game)
	waveNum = waveNum + 1
	
	if waveNum >= waveCount() then
		waveNum = 0	
	end

	game_setWaveNum(game, waveNum)
	
	local enemies = game_getEnemyList(game)
	game_clearList(enemies)
	spawnwave(enemies, waveNum)

	waveselect.refresh(game)
end

function prevwave(game)	
	local waveNum = game_getWaveNum(game)
	waveNum = waveNum - 1
	
	if waveNum < 0 then
		waveNum = waveCount() - 1	
	end	

	game_setWaveNum(game, waveNum)
	
	local enemies = game_getEnemyList(game)
	game_clearList(enemies)
	spawnwave(enemies, waveNum)

	waveselect.refresh(game)
end

function playselected(game)
	local enemies = game_getEnemyList(game)
	game_clearList(enemies)
	local bullets = game_getBulletList(game)
	game_clearList(bullets)
	game_setTimer(game, 0)

	local playerObject = game_getPlayer(game)
	player.start(playerObject)

	game_setWaveNum(game, game_getWaveNum(game))	
	game_setPaused(false)
	play(game)
end

function resetAndGoToMain(game)
	reset(game)
	game_setPaused(false)
	gotomain(game)
end

function waveselect.createmenu(game)
	menu_addTextToMenu(menuids.SELECT_WAVE, "Select Wave", 0.0, -64.0, 32.0)	

	local waveNum = game_getWaveNum(game)

	local bullets = game_getBulletList(game)
	game_clearList(bullets)
	local enemies = game_getEnemyList(game)
	game_clearList(enemies)
	spawnwave(enemies, waveNum)
	local playerObject = game_getPlayer(game)
	player.start(playerObject)

	if waveNum < waveCount() - 1 then
		menu_addTextToMenu(menuids.SELECT_WAVE, tostring(waveNum + 1), 0, -112, 32)
	else
		menu_addTextToMenu(menuids.SELECT_WAVE, "INF", 0, -112, 32)
	end

	menu_addButtonToMenu(menuids.SELECT_WAVE, "Play!", "playselected", 0.0, -176.0, 32.0)	
	menu_addButtonToMenu(menuids.SELECT_WAVE, "Main Menu", "resetAndGoToMain", 0, -216.0, 24.0)	

	menu_addButtonToMenu(menuids.SELECT_WAVE, ">", "nextwave", 64, -112, 32)
	menu_addButtonToMenu(menuids.SELECT_WAVE, "<", "prevwave", -64, -112, 32)

	menu_showGameobjects(menuids.SELECT_WAVE, true)
end

return waveselect
