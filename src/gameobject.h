#ifndef GAMEOBJECT_H

#include <lua.h>

#define DEFAULT_MAX_SZ 64

typedef struct 
{
	float x, y;
} Vector2f;

struct GameObject
{
	Vector2f pos, vel, dim; 
	int animationFrame, totalFrames;
	unsigned int image;
	char *scriptname;
	unsigned int health;
	double timer;
	int mode;
	int score;
	int z; // z coordinate of object,
		   // how much it should be prioritized in the drawing
};

struct GameObjectList
{
	struct GameObject *gameobjects;
	int enabled;
	unsigned long long size, _maxSize;
};

struct GameObjectPointerList
{
	struct GameObject **pointers;
	unsigned long long size, _maxSize;
};

struct Game
{
	struct GameObjectList bullets;
	struct GameObjectList enemies;
	struct GameObjectList visualEffects;
	struct GameObject player;
	struct GameObjectPointerList toDraw;
	int waveNum;
	int selectedMenu;
};

struct GameObject createObj(Vector2f pos, Vector2f vel, Vector2f dim, int maxFrames, 
							unsigned int img, const char *scriptname);
void animateObject(struct GameObject *obj);
void setTextureForObj(struct GameObject obj, 
					  float w, float h,
					  float fracX, float fracY,
					  float x, float y);
void setGameobjectScript(struct GameObject *obj, const char *scriptname);
void drawGameObject(struct GameObject obj);
Vector2f pt(float x, float y);

struct GameObjectList createGameObjectList();
void appendGameobject(struct GameObjectList *list, struct GameObject object);
void deleteGameObject(struct GameObjectList *list, int index);
void destroyGameObjectList(struct GameObjectList *list);

struct GameObjectPointerList createGameObjectPointerList();
void appendGameobjectPointer(struct GameObjectPointerList *list, struct GameObject *object);
void deleteGameObjectPointer(struct GameObjectPointerList *list, int index);
void destroyGameObjectPointerList(struct GameObjectPointerList *list);

int colliding(struct GameObject object1, struct GameObject object2);

lua_State* initLua();
void runLuaFile(lua_State *L, const char *path, const char *mod);
void runStartFunction(lua_State *L, const char *mod, struct GameObject *gameobject);
void runUpdateFunction(lua_State *L, const char *mod, struct GameObject *gameobject, struct Game *game, float timepassed);
int runOnCollisionFunction(lua_State *L, const char *mod, struct GameObject *gameobject, struct Game *game);
int runOnCollisionWithPlayerFunction(lua_State *L, const char *mod, struct GameObject *gameobject, struct Game *game);

//Gameobject API functions
int luaApi_setObjectPos(lua_State *L);
int luaApi_getObjectPos(lua_State *L);
int luaApi_setObjectVel(lua_State *L);
int luaApi_getObjectVel(lua_State *L);
int luaApi_setObjectSize(lua_State *L);
int luaApi_getObjectSize(lua_State *L);
int luaApi_getObjectHealth(lua_State *L);
int luaApi_setObjectHealth(lua_State *L);
int luaApi_getObjectTimer(lua_State *L);
int luaApi_setObjectTimer(lua_State *L);
int luaApi_setObjectFrameCount(lua_State *L);
int luaApi_getObjectFrameCount(lua_State *L);
int luaApi_getObjectFrame(lua_State *L);
int luaApi_setObjectFrame(lua_State *L);
int luaApi_getObjectMode(lua_State *L);
int luaApi_setObjectMode(lua_State *L);
int luaApi_setObjectScript(lua_State *L);
int luaApi_setObjectPicture(lua_State *L);
int luaApi_getObjectScore(lua_State *L);
int luaApi_setObjectScore(lua_State *L);
int luaApi_getObjectZ(lua_State *L);
int luaApi_setObjectZ(lua_State *L);
int luaApi_clearList(lua_State *L);
int luaApi_setWave(lua_State *L);
int luaApi_getWave(lua_State *L);
int luaApi_getPlayer(lua_State *L);

int luaApi_addEnemy(lua_State *L); //addEnemy(gameobjectList, x, y, vx, vy, szx, szy, frames, img, scriptname)
int luaApi_addObject(lua_State *L); //addObject(gameobjectList, x, y, img, scriptname)

int luaApi_getEnemyList(lua_State *L);
int luaApi_getBulletList(lua_State *L);
int luaApi_getVisualEffectList(lua_State *L);
int luaApi_getPlayerPos(lua_State *L);
int luaApi_getListSize(lua_State *L);
int luaApi_getGameobject(lua_State *L);

int luaApi_loadImage(lua_State *L);
int luaApi_loadScript(lua_State *L);

#endif

#define GAMEOBJECT_H
