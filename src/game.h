#ifndef GAME_H
#include "gameobject.h"

#define SPRITE_SIZE 48.0f
#define SPEED 128.0f
#define BULLET_SPEED 256.0f

//Update game objects
void update(struct Game *game,
			float timePassed,
			lua_State *L);
//Draw objects onto the window
//All sprites are 16 x 16
//Sprite animations are 64 x 16 pixels
void display(struct Game *game);
//Initialize OpenGL data
//Read/compile shaders, read textures, create window, etc
void initGL(void);
//Run this at the start of the game
void init(void);
//Main game loop
void loop(void);

#endif

#define GAME_H
