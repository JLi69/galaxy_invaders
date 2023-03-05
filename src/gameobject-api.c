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

int luaApi_setObjectSize(lua_State *L)
{
	CHECK_ARG_COUNT(3);

	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	gameobject->dim.x = lua_tointeger(L, 2);
	gameobject->dim.y = lua_tointeger(L, 3);

	return 0;
}

int luaApi_getObjectSize(lua_State *L)
{
	CHECK_ARG_COUNT(1);

	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	lua_pushnumber(L, gameobject->vel.x);
	lua_pushnumber(L, gameobject->vel.y);

	return 2;
}

int luaApi_getObjectHealth(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	lua_pushinteger(L, gameobject->health);
	return 1;
}

int luaApi_setObjectHealth(lua_State *L)
{
	CHECK_ARG_COUNT(2);
	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	gameobject->health = lua_tointeger(L, 2);
	return 0;
}

int luaApi_getObjectTimer(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	lua_pushnumber(L, gameobject->timer);
	return 1;
}

int luaApi_setObjectTimer(lua_State *L)
{
	CHECK_ARG_COUNT(2);
	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	gameobject->timer = lua_tonumber(L, 2);
	return 0;
}

int luaApi_setObjectFrameCount(lua_State *L)
{
	CHECK_ARG_COUNT(2);	
	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);	
	int frameCount = lua_tointeger(L, 2);
	gameobject->totalFrames = frameCount;
	return 0;
}

int luaApi_getObjectFrameCount(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);	
	lua_pushinteger(L, gameobject->totalFrames);
	return 1;
}

int luaApi_getObjectFrame(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	lua_pushinteger(L, gameobject->animationFrame);
	return 1;
}

int luaApi_setObjectFrame(lua_State *L)
{
	CHECK_ARG_COUNT(2);
	struct GameObject* gameobject = (struct GameObject*)lua_touserdata(L, 1);
	int frame = lua_tointeger(L, 2);
	gameobject->animationFrame = frame;
	return 0;
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

//addObject(gameobjectList, x, y, img)
int luaApi_addObject(lua_State *L)
{
	CHECK_ARG_COUNT(4);

	struct GameObjectList* gameobjectList = (struct GameObjectList*)lua_touserdata(L, 1);
	float x = lua_tonumber(L, 2),
		  y = lua_tonumber(L, 3);
	unsigned int imageId = getImageId(lua_tostring(L, 4));

	struct GameObject gameobject =
		createObj(pt(x, y), pt(0.0f, 0.0f), pt(0.0f, 0.0f), 
					  0, imageId);
	runStartFunction(L, "enemy", &gameobject);

	appendGameobject(gameobjectList, gameobject);

	return 0;
}

int luaApi_getEnemyList(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	struct Game* game = (struct Game*)lua_touserdata(L, 1);
	lua_pushlightuserdata(L, &game->enemies);
	return 1;
}

int luaApi_getBulletList(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	struct Game* game = (struct Game*)lua_touserdata(L, 1);
	lua_pushlightuserdata(L, &game->bullets);
	return 1;
}

int luaApi_getVisualEffectList(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	struct Game* game = (struct Game*)lua_touserdata(L, 1);
	lua_pushlightuserdata(L, &game->visualEffects);
	return 1;
}

int luaApi_getPlayerPos(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	struct Game* game = (struct Game*)lua_touserdata(L, 1);
	lua_pushnumber(L, game->player.pos.x);
	lua_pushnumber(L, game->player.pos.y);
	return 2;
}

int luaApi_getListSize(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	struct GameObjectList* gameobjects = (struct GameObjectList*)lua_touserdata(L, 1);
	lua_pushinteger(L, gameobjects->size);
	return 1;
}

int luaApi_getGameobject(lua_State *L)
{
	CHECK_ARG_COUNT(2);
	struct GameObjectList* gameobjects = (struct GameObjectList*)lua_touserdata(L, 1);
	int index = lua_tointeger(L, 2);
	
	//Out of range
	if(index >= gameobjects->size)
	{
		lua_pushnil(L);
		return 1;
	}

	lua_pushlightuserdata(L, &gameobjects->gameobjects[index]);
	return 1;
}

int luaApi_loadImage(lua_State *L)
{
	CHECK_ARG_COUNT(1);
	loadTexture(lua_tostring(L, 1));
	return 0;
}

int luaApi_loadScript(lua_State *L)
{
	runLuaFile(L, lua_tostring(L, 1), lua_tostring(L,2));
	return 0;
}
