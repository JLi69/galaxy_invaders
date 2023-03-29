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
#include "menu.h"

int main(void)
{
	for(int i = 0; i < MAX_MENU; i++)
		clearMenu(i);

	initGL();
	lua_State* L = initLua();

	double timepassed = 0.0;
	
	struct Game game;
	game.player = createObj(pt(0.0f, -300.0f), pt(0.0f, 0.0f), pt(SPRITE_SIZE, SPRITE_SIZE),
							4, getImageId("res/images/spaceship.png"), "player");
	game.bullets = createGameObjectList();
	game.enemies = createGameObjectList();
	game.visualEffects = createGameObjectList();
	game.toDraw = createGameObjectPointerList();
	game.selectedMenu = 0;
	game.timer = 0.0f;

	//Push constants
	lua_pushnumber(L, SPRITE_SIZE);
	lua_setglobal(L, "SPRITE_SIZE");

	runLuaFile(L, "res/scripts/prefabs.lua", "prefabs");	
	luaL_dofile(L, "res/scripts/spawnwave.lua");		
	luaL_dofile(L, "res/scripts/start.lua");

	lua_getglobal(L, "prefabs");
	luaL_checktype(L, -1, LUA_TTABLE);
	lua_getfield(L, -1, "init");
	if(lua_isfunction(L, -1))
	{
		lua_pcall(L, 0, 0, 0);
	}

	lua_getglobal(L, "startgame");
	if(lua_isfunction(L, -1))
	{
		lua_pushlightuserdata(L, &game);
		lua_pcall(L, 1, 0, 0);
		lua_pop(L, 1);
	}

	runStartFunction(L, game.player.scriptname, &game.player);

	game.player.score = 0;
	//Spawn first wave
	game.waveNum = 0;	

	while(!canQuit())
	{
		struct timeval start;
		gettimeofday(&start, 0);
		
		display(&game);
		drawMenu(game.selectedMenu);
		
		//Draw cursor on menu
		if(game.selectedMenu != GAME && cursorInBounds())
		{
			bindTexture(getImageId("res/images/icons.png"), GL_TEXTURE0);
			setTexOffset(0.0f, 0.0f);
			setRectSize(24.0f, 24.0f);
			double cursorX, cursorY;
			getCursorPos(&cursorX, &cursorY);
			setRectPos(cursorX, cursorY);
			drawRect();
		}

		if(game.selectedMenu != GAME)
		{
			//Hide/show mouse cursor
			if(cursorInBounds()) hideCursor();
			else enableCursor();
		}

		if(game.selectedMenu == GAME)
			disableCursor();

		update(&game, timepassed, L); 	
		interactWithMenu(game.selectedMenu, &game, L);
		updateWindow();	

		struct timeval end;
		gettimeofday(&end, 0);	
		timepassed = end.tv_sec - start.tv_sec + 1e-6 * (end.tv_usec - start.tv_usec);	
	}

	//Clean up
	destroyGameObjectList(&game.bullets);
	destroyGameObjectList(&game.enemies);
	destroyGameObjectList(&game.visualEffects);
	destroyGameObjectPointerList(&game.toDraw);
	lua_close(L);
	glfwTerminate();
}
