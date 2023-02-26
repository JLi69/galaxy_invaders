#ifndef GAME_H
#include "gameobject.h"

#define SPRITE_SIZE 48.0f
#define SPEED 128.0f
#define BULLET_SPEED 256.0f

//Update game objects
void update(struct GameObject *player,
			struct GameObjectList *bullets,
			struct GameObjectList *enemies,
			struct GameObjectList *visualEffects,
			float timePassed,
			lua_State *L);
//Draw objects onto the window
//All sprites are 16 x 16
//
//Player sprite is made up of a single image
//that is 64 x 16 pixels
//
//Enemies and bullets are individual images
//Enemies are 64 x 16 pixels
//Bullets are 32 x 16 pixels
void display(struct GameObject player,
			 struct GameObjectList bullets,
			 struct GameObjectList enemies,
			 struct GameObjectList visualEffects);
//Initialize OpenGL data
//Read/compile shaders, read textures, create window, etc
void initGL(void);
//Run this at the start of the game
void init(void);
//Main game loop
void loop(void);

#endif

#define GAME_H
