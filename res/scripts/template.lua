-- Enemy scripts will be of the following format:

-- Runs once when the enemy is spawned
-- Returns a table that contains the enemy data
function start()
	enemy = {}
	return enemy
end

-- This is run repeatedly in a loop and will update
-- the enemy in the game world
-- 
-- Pass in the enemy object as a table,
-- returns the updated enemy object
function update(enemy)
	return enemy
end
