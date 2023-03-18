#include "gameobject.h"
#include <lauxlib.h>
#include <lualib.h>
#include <string.h>
#include <stdlib.h>
#include "menu.h"

lua_State* initLua()
{
	lua_State* L = luaL_newstate();
	luaL_openlibs(L);
	
	//Import all api functions
	lua_register(L, "enemy_setObjectPos", luaApi_setObjectPos);
	lua_register(L, "enemy_setObjectVel", luaApi_setObjectVel);
	lua_register(L, "enemy_getObjectPos", luaApi_getObjectPos);
	lua_register(L, "enemy_getObjectVel", luaApi_getObjectVel);
	lua_register(L, "enemy_setObjectSize", luaApi_setObjectSize);
	lua_register(L, "enemy_getObjectSize", luaApi_getObjectSize);
	lua_register(L, "enemy_getObjectHealth", luaApi_getObjectHealth);
	lua_register(L, "enemy_setObjectHealth", luaApi_setObjectHealth);
	lua_register(L, "enemy_getObjectTimer", luaApi_getObjectTimer);
	lua_register(L, "enemy_setObjectTimer", luaApi_setObjectTimer);
	lua_register(L, "enemy_setObjectFrameCount", luaApi_setObjectFrameCount);
	lua_register(L, "enemy_getObjectFrameCount", luaApi_getObjectFrameCount);
	lua_register(L, "enemy_getObjectFrame", luaApi_getObjectFrame);
	lua_register(L, "enemy_setObjectFrame", luaApi_setObjectFrame);
	lua_register(L, "enemy_getObjectMode", luaApi_getObjectMode);
	lua_register(L, "enemy_setObjectMode", luaApi_setObjectMode);
	lua_register(L, "enemy_setObjectScript", luaApi_setObjectScript);
	lua_register(L, "enemy_setObjectPicture", luaApi_setObjectPicture);
	lua_register(L, "enemy_getObjectScore", luaApi_getObjectScore);
	lua_register(L, "enemy_setObjectScore", luaApi_setObjectScore);
	lua_register(L, "enemy_getObjectZ", luaApi_getObjectZ);
	lua_register(L, "enemy_setObjectZ", luaApi_setObjectZ);

	lua_register(L, "game_addEnemy", luaApi_addEnemy);	
	lua_register(L, "game_addObject", luaApi_addObject);
	lua_register(L, "game_getEnemyList", luaApi_getEnemyList);
	lua_register(L, "game_getBulletList", luaApi_getBulletList);
	lua_register(L, "game_getVisualEffectList", luaApi_getVisualEffectList);
	lua_register(L, "game_getPlayerPos", luaApi_getPlayerPos);
	lua_register(L, "game_sizeofList", luaApi_getListSize);
	lua_register(L, "game_getGameObjectAt", luaApi_getGameobject);	

	lua_register(L, "game_loadTexture", luaApi_loadImage);
	lua_register(L, "game_loadScript", luaApi_loadScript);

	lua_register(L, "menu_addTextToMenu", luaApi_addTextToMenu);
	lua_register(L, "menu_addButtonToMenu", luaApi_addButtonToMenu);
	lua_register(L, "menu_gotoMenu", luaApi_gotoMenu);
	lua_register(L, "menu_getMenuId", luaApi_getCurrentMenuId);
	lua_register(L, "game_setPaused", luaApi_setPaused);

	return L;
}

void runLuaFile(lua_State *L, const char *path, const char *mod)
{
	luaL_dofile(L, path);
	//import the module
	lua_getglobal(L, "require");
	lua_pushstring(L, mod);
	lua_pcall(L, 1, 1, 0);	
	lua_pop(L, 1);
	lua_setglobal(L, mod);
}

void runStartFunction(lua_State *L, const char *mod, struct GameObject *gameobject)
{
	if(mod == NULL)
		return;

	lua_getglobal(L, mod);	
	if(lua_isnil(L, -1))
	{
		fprintf(stderr, "%s is nil!\n", mod);
		return;
	}

	luaL_checktype(L, -1, LUA_TTABLE);
	lua_getfield(L, -1, "start");
	if(lua_isfunction(L, -1))
	{
		lua_pushlightuserdata(L, gameobject);
		lua_pcall(L, 1, 0, 0);
		lua_pop(L, -1);	
	}
}

void runUpdateFunction(lua_State *L, const char *mod, struct GameObject *gameobject, struct Game *game,
					   float timepassed)
{	
	if(mod == NULL)
		return;

	lua_getglobal(L, mod);
	if(lua_isnil(L, -1))
	{
		fprintf(stderr, "%s is nil!\n", mod);
		return;
	}

	luaL_checktype(L, -1, LUA_TTABLE);
	lua_getfield(L, -1, "update");	

	if(lua_isfunction(L, -1))
	{
		lua_pushlightuserdata(L, gameobject);
		lua_pushlightuserdata(L, game);	
		lua_pushnumber(L, timepassed);
		lua_pcall(L, 3, 0, 0);
		lua_pop(L, -1);
		lua_pop(L, -2);
		lua_pop(L, -3);
	}
}

int runOnCollisionFunction(lua_State *L, const char *mod, struct GameObject *gameobject, struct Game *game)
{
	if(mod == NULL)
		return 0;

	lua_getglobal(L, mod);
	if(lua_isnil(L, -1))
	{
		fprintf(stderr, "%s is nil!\n", mod);
		return 0;
	}

	int ret = 0;
	luaL_checktype(L, -1, LUA_TTABLE);
	lua_getfield(L, -1, "oncollision");
	if(lua_isfunction(L, -1))
	{
		lua_pushlightuserdata(L, gameobject);
		lua_pushlightuserdata(L, game);	
		lua_pcall(L, 2, 1, 0);
		ret = lua_toboolean(L, -1);
		lua_pop(L, -1);
		lua_pop(L, -2);
		lua_pop(L, -3);
	}
	return ret;
}

int runOnCollisionWithPlayerFunction(lua_State *L, const char *mod, struct GameObject *gameobject, struct Game *game)
{
	if(mod == NULL)
		return 0;

	lua_getglobal(L, mod);
	if(lua_isnil(L, -1))
	{
		fprintf(stderr, "%s is nil!\n", mod);
		return 0;
	}

	int ret = 0;
	luaL_checktype(L, -1, LUA_TTABLE);
	lua_getfield(L, -1, "oncollisionwithplayer");
	if(lua_isfunction(L, -1))
	{
		lua_pushlightuserdata(L, gameobject);
		lua_pushlightuserdata(L, game);	
		lua_pcall(L, 2, 1, 0);
		ret = lua_toboolean(L, -1);
		lua_pop(L, -1);
		lua_pop(L, -2);
		lua_pop(L, -3);
	}
	return ret;
}
