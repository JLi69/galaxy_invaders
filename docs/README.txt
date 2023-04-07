Documentation for Galaxy Invaders
---------------------------------

When the game is run, the following occurs:
 - prefabs.lua gets imported
 - spawnwave.lua gets run
 - player.lua is imported
 - start.lua is run
 - prefabs.init() is called
 - startgame() is called
 - player.start() is called
 Main loop:
	- Sprites are drawn to screen (not controlled by lua)
	- Sprites are updated by lua 
 - Cleanup

IMPORTANT: when importing files in lua scripts for the game,
note that everything is imported from the executable's working
directory which means that if the file is in res/scripts and is
called foo.lua, we would need to do the following:

local foo = require("res.scripts.foo")

spawnwave.lua
-------------
Whenever there are no more enemies on the screen and no more enemies
are going to be added to the screen, the game calls spawnwave() which
is given two parameters: a user data pointing to the enemy list and the
current wave number.

function spawnwave(enemies, waveNum)
	if waveNum + 1 <= #spawnWaveFunctions then 
		spawnWaveFunctions[waveNum + 1](enemies)
	else
		spawnWaveFunctions[#spawnWaveFunctions](enemies)
	end
end

spawnWaveFunctions is a local table in the file that contains the functions
for spawning in enemies for various waves and one can simply add a function
to the table to add another wave to the game. The final wave is randomly
generated but it can be changed to do something else.

start.lua
---------
startgame is a function that is given a single parameter - the user data
for the game data and then is called once and is assumed to never be called
again. Insert code here that you want run at startup.

prefabs.lua
-----------
This is the file for defining "prefabs" or templates of enemies or bullets
or other gameobjects that are going to be identical.

prefabs.init() is called and imports all scripts associated with prefabs
as global modules and then also loads textures associated with those prefabs.
If you want to import textures and scripts that are not going to immediately
be used by prefabs, you are going to have to manually import those.

prefabs.newprefab(name, luapath, mod, imagepath)
This function creates a prefab with a name and imports the script at
'luapath' to define behavior for the object by importing the module of
name 'mod' as a global module and then associates the image at 'imagepath'
with the object.

Example:
-- Creates a prefab with name "alien" and then
-- runs res/scripts/enemies/alien.lua and enemies/alien.lua
-- is assumed to have a module with name "alien" and it then
-- calls alien = require("alien") 
-- Any "alien" sprites will be displayed with res/images/alien.png by default
prefabs.newprefab("alien", "res/scripts/enemies/alien.lua", "alien", "res/images/alien.png")

prefabs.loadres()
imports all scripts and textures needed by prefabs, assumed to be called only
once and after all prefabs have been defined in prfabs.init()

prefabs.addPrefab(gameobjectlist, x, y, sprite)
gameobjectlist - user data pointing to a gameobject list
x, y - coordiantes to place the new prefab
sprite - string that is the name associated with the prefab

IMPORTANT: gameobjectlist must not be nil or the game will crash!

Example:
local enemies = game_getEnemyList(game)
-- Adds a single sprite to the gameobject list
-- enemies of the prefab "alien" at the
-- coordinates (0, 0)
prefabs.addPrefab(enemies, 0, 0, "alien")

structure of [gameobject].lua
-----------------------------

Template enemy code:

--------------------
local enemy = {}

-- run this upon enemy start
function enemy.start(self)

end

function enemy.update(self, game, timepassed)
	 
end

-- run this when the enemy collides with a bullet
-- returns a value true or false,
-- if the value is true, then delete the enemy,
-- if the value is false, then do not delete the enemy
function enemy.oncollision(self, game)		
	-- Delete object if health is less than or equal to 0
	return true
end

return enemy
--------------------

The module is named 'enemy' and the function enemy.start(self)
is called when the enemy is created and is not called again by the game,
this is meant to initailize values such as health, score value, and velocity
of the enemy. The parameter 'self' is a user data pointing to data
associated with the enemy.

enemy.update(self, game, timepassed) is called every frame and is given three arguments:
 - self
	- User data pointing to sprite data
 - game
	- User data pointing to game data
 - timepassed
	- Number that is the amount of time the previous frame took,
	  use this to update the enemy's internal timer 
	  (see enemy_setObjectTimer)
	  
	  And also for moving the enemy at a fixed speed regardless of frame rate:	
	  
	  -- Get object's position
	  x, y = enemy_getObjectPos(gameobject)
	  -- Get velocity
	  velx, vely = enemy_getObjectVel(gameobject)
	  -- move the object
	  enemy_setObjectPos(gameobject, x + velx * timepassed, y + vely * timepassed)

enemy.oncollision(self, game) is called when the enemy collides with a bullet the player shot.
It is given two arguments: self and game - self is the user data pointing to the enemy and
game is user data pointing to the game data struct.

Example code for how an enemy might behave when shot by a bullet follows:

function enemy.oncollision(self, game)
	-- Lower health by one when shot
	health = enemy_getObjectHealth(self)
	health = health - 1
	enemy_setObjectHealth(self, health)

	-- if out of health, explode
	if health <= 0 then
		x, y = enemy_getObjectPos(self)
		local vis = game_getVisualEffectList(game)
		prefabs.addPrefab(vis, x, y, "explosion")
	end
	
	-- Delete object if health is less than or equal to 0
	return health <= 0
end

If the function enemy.oncollision returns true, the object is deleted from the game object list.
If it returns false, the program keeps it in the list.
