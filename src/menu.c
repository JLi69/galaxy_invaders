#include "menu.h"
#include <string.h>
#include "draw.h"
#include "window-func.h"
#define GLFW_INCLUDE_NONE
#include <GLFW/glfw3.h>
#include <stdio.h>
#include "gl-func.h"
#include <glad/glad.h>

struct Menu menus[MAX_MENU];

void drawTextButton(struct MenuObj obj)
{
	if(buttonHover(obj))
		setBrightness(0.5f);
	else
		setBrightness(1.0f);
	drawString(obj.text, obj.x, obj.y, obj.charSz);
}

int buttonHover(struct MenuObj button)
{
	double cursorX, cursorY;
	getCursorPos(&cursorX, &cursorY);

	float width = strlen(button.text) * button.charSz;
	
	if(button.y + button.charSz / 2.0f >= cursorY &&
	   button.y - button.charSz / 2.0f <= cursorY &&
	   button.x - width / 2.0f <= cursorX &&
	   button.x + width / 2.0f >= cursorX)
		return 1;
	return 0;
}

int buttonClicked(int menu, int buttonInd, int mouseButton)
{
	if(menu < 0)
		return 0;

	double cursorX, cursorY;
	getCursorPos(&cursorX, &cursorY);

	float width = strlen(menus[menu].menuButtons[buttonInd].text) * 
				  menus[menu].menuButtons[buttonInd].charSz;
	
	if(menus[menu].menuButtons[buttonInd].y + menus[menu].menuButtons[buttonInd].charSz / 2.0f >= cursorY &&
	   menus[menu].menuButtons[buttonInd].y - menus[menu].menuButtons[buttonInd].charSz / 2.0f <= cursorY &&
	   menus[menu].menuButtons[buttonInd].x - width / 2.0f <= cursorX &&
	   menus[menu].menuButtons[buttonInd].x + width / 2.0f >= cursorX &&
	   mouseButtonHeld(mouseButton))
	{
		releaseMouseButton(mouseButton);
		return 1;
	}
	return 0;
}

void drawMenu(int menu)
{
	if(menu < 0 || menu >= MAX_MENU)
		return;
	bindTexture(getImageId("res/images/icons.png"), GL_TEXTURE0);
	setTexFrac(1.0f / 16.0f, 1.0f / 16.0f);
	setTexSize(256.0f, 256.0f);

	for(int i = 0; i < menus[menu].buttonCount; i++)
	{
		if(buttonHover(menus[menu].menuButtons[i])) setBrightness(0.5f);
		else setBrightness(1.0f);
		drawString(menus[menu].menuButtons[i].text,
				   menus[menu].menuButtons[i].x,
				   menus[menu].menuButtons[i].y,
				   menus[menu].menuButtons[i].charSz);
	}
	setBrightness(1.0f);

	for(int i = 0; i < menus[menu].textCount; i++)
	{
		drawString(menus[menu].menuText[i].text,
				   menus[menu].menuText[i].x,
				   menus[menu].menuText[i].y,
				   menus[menu].menuText[i].charSz);
	}
}

struct Menu emptyMenu()
{	
	struct Menu menu;
	menu.buttonCount = 0;
	menu.textCount = 0;
	return menu;
}

struct MenuObj createMenuObj(const char *str, float x, float y, float chSz)
{
	struct MenuObj menuobj;
	menuobj.x = x;
	menuobj.y = y;
	menuobj.charSz = chSz;
	strncpy(menuobj.text, str, MAX_TEXT_LEN);
	menuobj.text[MAX_TEXT_LEN] = '\0';
	menuobj.onclickFunc[0] = '\0';
	return menuobj;
}

void addButtonToMenu(struct Menu *menu, const char *text, const char *onclickFunc, float x, float y, float sz)
{
	if(menu->buttonCount >= MAX_BUTTONS)
		return;
	menu->menuButtons[menu->buttonCount++] = createMenuObj(text, x, y, sz);
	strncpy(menu->menuButtons[menu->buttonCount - 1].onclickFunc, onclickFunc, MAX_TEXT_LEN);
	menu->menuButtons[menu->buttonCount - 1].onclickFunc[MAX_TEXT_LEN] = '\0'; 
}

void addTextToMenu(struct Menu *menu, const char *text, float x, float y, float sz)
{
	if(menu->textCount >= MAX_TEXT)
		return;
	menu->menuText[menu->textCount++] = createMenuObj(text, x, y, sz);
}

struct Menu* getMenuFromId(int id)
{
	if(id < 0 || id >= MAX_MENU)
		return NULL;
	return &menus[id];
}

void interactWithMenu(int menuId, struct Game *game, lua_State *L)
{
	if(menuId < 0 || menuId >= MAX_MENU)
		return;

	for(int i = 0; i < menus[menuId].buttonCount; i++)
	{	
		if(buttonClicked(menuId, i, GLFW_MOUSE_BUTTON_LEFT))
		{
			lua_getglobal(L, menus[menuId].menuButtons[i].onclickFunc);
			if(lua_isfunction(L, -1))
			{
				lua_pushlightuserdata(L, game);
				lua_pcall(L, 1, 0, 0);	
			}
		}	
	}
}
