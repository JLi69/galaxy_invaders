#include "game.h"
#include "draw.h"
#include "gl-func.h"
#include <glad/glad.h>
#include "window-func.h"
#include <stdlib.h>

static struct ShaderProgram shaderProgram;
static struct Buffers rectangleBuffer;

void initGL(void)
{
	initWindow("Galaxy Invaders");

	//Set up program
	shaderProgram = createShaderProgram("res/shaders/gameobject.vert", 
													   "res/shaders/gameobject.frag");
	useShader(&shaderProgram);
	//Set up rectangle
	rectangleBuffer = createRectangleBuffer();
	bindBuffers(rectangleBuffer);

	loadTexture("res/images/icons.png");
	loadTexture("res/images/spaceship.png");
	loadTexture("res/images/background.png");

	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

int compareGameObjectZ(const void *gameobject1, const void *gameobject2)
{
	return (*((struct GameObject**)gameobject1))->z - (*((struct GameObject**)gameobject2))->z;
}

void display(struct Game *game)
{
	clear();

	updateActiveShaderWindowSize();

	bindTexture(getImageId("res/images/background.png"), GL_TEXTURE0);
	setRectPos(0.0f, 0.0f);
	setRectSize(1920.0f, 1080.0f);
	setTexSize(640.0f, 360.0f);
	setTexFrac(1.0f, 1.0f);
	setTexOffset(0.0f, 0.0f);
	drawRect();

	for(int i = 0; i < game->bullets.size; i++)
		appendGameobjectPointer(&game->toDraw, &game->bullets.gameobjects[i]);
	for(int i = 0; i < game->enemies.size; i++)
		appendGameobjectPointer(&game->toDraw, &game->enemies.gameobjects[i]);
	for(int i = 0; i < game->visualEffects.size; i++)
		appendGameobjectPointer(&game->toDraw, &game->visualEffects.gameobjects[i]);
	appendGameobjectPointer(&game->toDraw, &game->player);
	
	qsort(game->toDraw.pointers, game->toDraw.size, sizeof(void*), compareGameObjectZ); 

	//Draw gameobjects 
	unsigned int prevTexture = -1;
	for(int i = 0; i < game->toDraw.size; i++)
	{
		if(game->toDraw.pointers[i]->image != prevTexture)
		{
			bindTexture(game->toDraw.pointers[i]->image, GL_TEXTURE0);
			prevTexture = game->toDraw.pointers[i]->image;
		}
		setTextureForObj(*game->toDraw.pointers[i], 64.0f, 16.0f, 1.0f / 4.0f, 1.0f, 0.0f, 0.0f);	
		drawGameObject(*game->toDraw.pointers[i]);
	}

	/*for(int i = 0; i < game.bullets.size; i++)
	{
		if(game.bullets.gameobjects[i].image != prevTexture)
		{
			bindTexture(game.bullets.gameobjects[i].image, GL_TEXTURE0);
			prevTexture = game.bullets.gameobjects[i].image;	
		}
		setTextureForObj(game.bullets.gameobjects[i], 32.0f, 16.0f, 1.0f / 2.0f, 1.0f, 0.0f, 0.0f);
		drawGameObject(game.bullets.gameobjects[i]);
	}

	for(int i = 0; i < game.enemies.size; i++)
	{
		if(game.enemies.gameobjects[i].image != prevTexture)
		{
			bindTexture(game.enemies.gameobjects[i].image, GL_TEXTURE0);
			prevTexture = game.enemies.gameobjects[i].image;	
		}
		setTextureForObj(game.enemies.gameobjects[i], 64.0f, 16.0f, 1.0f / 4.0f, 1.0f, 0.0f, 0.0f);
		drawGameObject(game.enemies.gameobjects[i]);
	}

	for(int i = 0; i < game.visualEffects.size; i++)
	{
		if(game.visualEffects.gameobjects[i].image != prevTexture)
		{
			bindTexture(game.visualEffects.gameobjects[i].image, GL_TEXTURE0);
			prevTexture = game.visualEffects.gameobjects[i].image;	
		}
		setTextureForObj(game.visualEffects.gameobjects[i], 64.0f, 16.0f, 1.0f / 4.0f, 1.0f, 0.0f, 0.0f);
		drawGameObject(game.visualEffects.gameobjects[i]);
	}

	//Draw player
	bindTexture(game.player.image, GL_TEXTURE0);
	setTextureForObj(game.player, 64.0f, 16.0f, 1.0f / 4.0f, 1.0f, 0.0f, 0.0f);	
	drawGameObject(game.player);*/	

	//Draw lives
	{
		bindTexture(getImageId("res/images/spaceship.png"), GL_TEXTURE0);
		int w, h;
		getWindowSize(&w, &h);
		float iconX = -(float)w / 2.0f + 64.0f,
			  iconY = (float)h / 2.0f - 64.0f;
		setRectSize(32.0f, 32.0f);
		setTexSize(64.0f, 16.0f);
		setTexFrac(1.0f / 4.0f, 1.0f);
		setTexOffset(0.0f, 0.0f);
		for(int i = 0; i < game->player.health; i++)
		{
			setRectPos(iconX, iconY);
			drawRect();
			iconX += 32.0f;
		}
	}

	if(isPaused())
	{
		setTexFrac(1.0f / 16.0f, 1.0f / 16.0f);
		setTexSize(256.0f, 256.0f);
		bindTexture(getImageId("res/images/icons.png"), GL_TEXTURE0);
		
		turnOffTexture();
		setRectPos(0.0f, 0.0f);
		int w, h;
		getWindowSize(&w, &h);
		setRectSize((float)w, (float)h);
		setRectColor(128.0f, 128.0f, 128.0f, 128.0f);
		drawRect();
		turnOnTexture();

		drawString("Paused", 0.0f, 0.0f, 64.0f);
	}
	else if(game->player.health <= 0)
	{
		setTexFrac(1.0f / 16.0f, 1.0f / 16.0f);
		setTexSize(256.0f, 256.0f);	
		
		turnOffTexture();
		setRectPos(0.0f, 0.0f);
		int w, h;
		getWindowSize(&w, &h);
		setRectSize((float)w, (float)h);
		setRectColor(255.0f, 0.0f, 0.0f, 128.0f);
		drawRect();
		turnOnTexture();
		
		bindTexture(getImageId("res/images/icons.png"), GL_TEXTURE0);
		drawString("Game Over!", 0.0f, 0.0f, 64.0f);
	}

	outputGLErrors();
	destroyGameObjectPointerList(&game->toDraw);
	game->toDraw = createGameObjectPointerList();
}
