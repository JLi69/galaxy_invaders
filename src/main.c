#include "game.h"
#if defined(__linux__) || defined(__MINGW64__) || defined(__GNUC__) 
#include <sys/time.h>
#else
#error "Need to find sys/time.h to compile! If you are on Windows use MinGW"
#endif
#include "window-func.h"
#include "gl-func.h"
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include "draw.h"
#include <lauxlib.h>
#include <lualib.h>

#include <stdio.h>

int main(void)
{
	initGL();
	lua_State* L = initLua();

	double timepassed = 0.0;
	
	struct Game game;
	game.player = createObj(pt(0.0f, -300.0f), pt(0.0f, 0.0f), pt(SPRITE_SIZE, SPRITE_SIZE),
							4, getImageId("res/images/spaceship.png"), "player");
	game.bullets = createGameObjectList();
	game.enemies = createGameObjectList();
	game.visualEffects = createGameObjectList();

	//Push constants
	lua_pushnumber(L, SPRITE_SIZE);
	lua_setglobal(L, "SPRITE_SIZE");

	runLuaFile(L, "res/scripts/prefabs.lua", "prefabs");	
	luaL_dofile(L, "res/scripts/spawnwave.lua");	

	lua_getglobal(L, "prefabs");
	luaL_checktype(L, -1, LUA_TTABLE);
	lua_getfield(L, -1, "init");
	if(lua_isfunction(L, -1))
	{
		lua_pcall(L, 0, 0, 0);
	}

	//Spawn first wave
	int waveNum = 0;
	lua_getglobal(L, "spawnwave");
	if(lua_isfunction(L, -1))
	{
		lua_pushlightuserdata(L, &game.enemies);
		lua_pushinteger(L, waveNum);
		lua_pcall(L, 2, 0, 0);
		lua_pop(L, -1);
		lua_pop(L, -2);
	}

	while(!canQuit())
	{
		struct timeval start;
		gettimeofday(&start, 0);
		
		display(game);
		if(!isPaused())
		{
			update(&game, timepassed, L); 
			//Are all enemies dead?
			//If all enemies have been killed, attempt to spawn the next wave
			if(game.enemies.size == 0)
			{
				//Spawn next wave
				waveNum++;	
				lua_getglobal(L, "spawnwave");
				if(lua_isfunction(L, -1))
				{
					lua_pushlightuserdata(L, &game.enemies);
					lua_pushinteger(L, waveNum);
					lua_pcall(L, 2, 0, 0);
					lua_pop(L, -1);
					lua_pop(L, -2);
				}
			}
		}

		updateWindow();
		struct timeval end;
		gettimeofday(&end, 0);	
		timepassed = end.tv_sec - start.tv_sec + 1e-6 * (end.tv_usec - start.tv_usec);
	}

	//Clean up
	destroyGameObjectList(&game.bullets);
	destroyGameObjectList(&game.enemies);
	destroyGameObjectList(&game.visualEffects);
	lua_close(L);
}
