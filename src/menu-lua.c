#include "menu.h"
#include "gameobject.h"
#include "window-func.h"
#include <stdio.h>

#define CHECK_ARG_COUNT(arg_count) \
	if(lua_gettop(L) != arg_count) \
	{ \
		fprintf(stderr, "Error: function requires %d arguments\n", arg_count); \
		fprintf(stderr, "Actual argument count: %d \n", lua_gettop(L)); \
		return 0; \
	}

int luaApi_addTextToMenu(lua_State *L)
{
	CHECK_ARG_COUNT(5);

	int menu = lua_tointeger(L, 1);
	if(menu < 0 || menu >= MAX_MENU)
	{
		lua_pop(L, 2);
		lua_pop(L, 3);
		lua_pop(L, 4);
		lua_pop(L, 5);
		return 0;
	}
	addTextToMenu(getMenuFromId(menu), 
				  lua_tostring(L, 2),
				  lua_tonumber(L, 3),
				  lua_tonumber(L, 4),
				  lua_tonumber(L, 5));
	return 0;
}

int luaApi_addButtonToMenu(lua_State *L)
{
	CHECK_ARG_COUNT(6);

	int menu = lua_tointeger(L, 1);
	if(menu < 0 || menu >= MAX_MENU)
	{
		lua_pop(L, 2);
		lua_pop(L, 3);
		lua_pop(L, 4);
		lua_pop(L, 5);	
		lua_pop(L, 6);
		return 0;
	}
	addButtonToMenu(getMenuFromId(menu), 
				  lua_tostring(L, 2),
				  lua_tostring(L, 3),
				  lua_tonumber(L, 4),
				  lua_tonumber(L, 5),
				  lua_tonumber(L, 6));
	return 0;
}

int luaApi_gotoMenu(lua_State *L)
{
	CHECK_ARG_COUNT(2);

	struct Game* game = lua_touserdata(L, 1);
	game->selectedMenu = lua_tointeger(L, 2);
	
	// -2 = quit
	if(game->selectedMenu == QUIT)
		quit();
	
	return 0;
}

int luaApi_getCurrentMenuId(lua_State *L)
{
	CHECK_ARG_COUNT(1);

	struct Game* game = lua_touserdata(L, 1);
	lua_pushinteger(L, game->selectedMenu);
	return 1;
}

int luaApi_setPaused(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	setPaused(lua_toboolean(L, 1));
	return 0;
}

int luaApi_clearMenu(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	clearMenu(lua_tointeger(L, 1));
	return 0;
}
