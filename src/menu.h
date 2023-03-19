#ifndef MENU_H
#include <lua.h>
#include "gameobject.h"
#define MAX_TEXT_LEN 64
#define MAX_BUTTONS 64
#define MAX_TEXT 64
#define MAX_MENU 16


enum MenuId
{
	QUIT = -2,
	GAME = -1,
	MAIN = 0,
	CREDITS = 1,
	HISCORE = 2,
	PAUSE = 3,
	GAMEOVER = 4
};

struct MenuObj 
{
	float x, y, charSz;
	char text[MAX_TEXT_LEN + 1];
	char onclickFunc[MAX_TEXT_LEN + 1]; //Name of lua function to be called when this is clicked
									    //If it is an empty string, do nothing
};

struct Menu
{
	struct MenuObj menuButtons[MAX_BUTTONS];
	struct MenuObj menuText[MAX_TEXT];
	int buttonCount, textCount;
	int displayGameobjects;
	float backgroundR, backgroundG, backgroundB, backgroundA;
};

//Button darkens when you hover over it
int buttonHover(struct MenuObj button);
int buttonClicked(int menu, int buttonInd, int mouseButton);
void drawMenu(int menu);

struct Menu emptyMenu();
void clearMenu(int menuid);
struct MenuObj createMenuObj(const char *str, float x, float y, float chSz);
void addTextToMenu(struct Menu *menu, const char *text, float x, float y, float sz);
void addButtonToMenu(struct Menu *menu, const char *text, const char *onclickFunc, float x, float y, float sz);

void drawTextButton(struct MenuObj obj);

struct Menu* getMenuFromId(int id);

//Menu lua API functions
int luaApi_addTextToMenu(lua_State *L);
int luaApi_addButtonToMenu(lua_State *L);
int luaApi_gotoMenu(lua_State *L);
int luaApi_getCurrentMenuId(lua_State *L);
int luaApi_setPaused(lua_State *L);
int luaApi_clearMenu(lua_State *L);
int luaApi_setDisplayGameObjects(lua_State *L);
int luaApi_setBackgroundColor(lua_State *L);

void interactWithMenu(int menuId, struct Game *game, lua_State *L);

#endif

#define MENU_H
