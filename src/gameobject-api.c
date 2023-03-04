#include "gameobject.h"
#include <stdio.h>
#include "gl-func.h"

#define CHECK_ARG_COUNT(arg_count) \
	if(lua_gettop(L) != arg_count) \
	{ \
		fprintf(stderr, "Error: function requires %d arguments\n", arg_count); \
		fprintf(stderr, "Actual argument count: %d \n", lua_gettop(L)); \
		return 0; \
	}

//Gameobject API functions
int luaApi_setObjectPos(lua_State *L)
{
	CHECK_ARG_COUNT(3);

	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	float x = lua_tonumber(L, 2),
		  y = lua_tonumber(L, 3);
	gameobject->pos.x = x;
	gameobject->pos.y = y;
	return 0;
}

int luaApi_setObjectVel(lua_State *L)
{
	CHECK_ARG_COUNT(3);

	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	float xvel = lua_tonumber(L, 2),
		  yvel = lua_tonumber(L, 3);
	gameobject->vel.x = xvel;
	gameobject->vel.y = yvel;
	return 0;
}

int luaApi_getObjectPos(lua_State *L)
{
	CHECK_ARG_COUNT(1);

	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	lua_pushnumber(L, gameobject->pos.x);
	lua_pushnumber(L, gameobject->pos.y);

	return 2;
}

int luaApi_getObjectVel(lua_State *L)
{
	CHECK_ARG_COUNT(1);

	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	lua_pushnumber(L, gameobject->vel.x);
	lua_pushnumber(L, gameobject->vel.y);

	return 2;
}

//addEnemy(gameobjectList, x, y, vx, vy, szx, szy, frames, img)
int luaApi_addEnemy(lua_State *L)
{
	CHECK_ARG_COUNT(9);

	struct GameObjectList* gameobjectList = (struct GameObjectList*)lua_touserdata(L, 1);
	float x = lua_tonumber(L, 2),
		  y = lua_tonumber(L, 3),
		  velX = lua_tonumber(L, 4),
		  velY = lua_tonumber(L, 5),
		  sizeX = lua_tonumber(L, 6),
		  sizeY = lua_tonumber(L, 7);
	int frameCount = lua_tointeger(L, 8);
	unsigned int imageId = getImageId(lua_tostring(L, 9));

	struct GameObject gameobject =
			createObj(pt(x, y), pt(velX, velY), pt(sizeX, sizeY), 
					  frameCount, imageId);
	runStartFunction(L, "enemy", &gameobject);

	appendGameobject(gameobjectList, gameobject);

	return 0;
}
