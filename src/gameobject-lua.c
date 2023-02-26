#include "gameobject.h"
#include <lauxlib.h>
#include <lualib.h>
#include <string.h>
#include <stdlib.h>

lua_State* initLua()
{
	lua_State* L = luaL_newstate();
	luaL_openlibs(L);
	
	//Import all api functions
	lua_register(L, "_setObjectPos", luaApi_setObjectPos);
	lua_register(L, "_setObjectVel", luaApi_setObjectVel);
	lua_register(L, "_getObjectPos", luaApi_getObjectPos);
	lua_register(L, "_getObjectVel", luaApi_getObjectVel);

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
	//Some checks to make sure that the file is of the right format
}

void runStartFunction(lua_State *L, const char *mod, struct GameObject *gameobject)
{
	lua_getglobal(L, mod);
	luaL_checktype(L, -1, LUA_TTABLE);
	lua_getfield(L, -1, "start");
	if(lua_isfunction(L, -1))
	{
		lua_pushlightuserdata(L, gameobject);
		lua_pcall(L, 1, 0, 0);
		lua_pop(L, -1);	
	}
}

void runUpdateFunction(lua_State *L, const char *mod, struct GameObject *gameobject, float timepassed)
{	
	lua_getglobal(L, mod);
	luaL_checktype(L, -1, LUA_TTABLE);
	lua_getfield(L, -1, "update");
	if(lua_isfunction(L, -1))
	{
		lua_pushlightuserdata(L, gameobject);
		lua_pushnumber(L, timepassed);
		lua_pcall(L, 2, 0, 0);
		lua_pop(L, -1);
		lua_pop(L, -2);
	}
}
