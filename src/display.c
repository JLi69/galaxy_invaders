#include "game.h"
#include "draw.h"
#include "gl-func.h"
#include <glad/glad.h>
#include "window-func.h"
#include <stdlib.h>
#include <math.h>
#include "menu.h"

#include <stdio.h>

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

	for(int i = 0; i < game->bullets.size && (game->selectedMenu == GAME || getMenuFromId(game->selectedMenu)->displayGameobjects); i++)
		appendGameobjectPointer(&game->toDraw, &game->bullets.gameobjects[i]);
	for(int i = 0; i < game->enemies.size && (game->selectedMenu == GAME || getMenuFromId(game->selectedMenu)->displayGameobjects); i++)
		appendGameobjectPointer(&game->toDraw, &game->enemies.gameobjects[i]);
	for(int i = 0; i < game->visualEffects.size; i++)
		appendGameobjectPointer(&game->toDraw, &game->visualEffects.gameobjects[i]);
	if(game->selectedMenu == GAME || getMenuFromId(game->selectedMenu)->displayGameobjects)
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
		setRotationRad(game->toDraw.pointers[i]->rotation);
		setTextureForObj(*game->toDraw.pointers[i], 64.0f, 16.0f, 1.0f / 4.0f, 1.0f, 0.0f, 0.0f);	
		drawGameObject(*game->toDraw.pointers[i]);
	}
	setRotationRad(0.0f);
	
	//Draw lives
	if(game->selectedMenu == GAME)
	{
		bindTexture(getImageId("res/images/spaceship.png"), GL_TEXTURE0);
		int w, h;
		getWindowSize(&w, &h);
		float iconX = -(float)w / 2.0f + 32.0f,
			  iconY = (float)h / 2.0f - 32.0f;
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

	//Draw score and current wave
	if(game->selectedMenu == GAME)
	{
		bindTexture(getImageId("res/images/icons.png"), GL_TEXTURE0);
		setTexFrac(1.0f / 16.0f, 1.0f / 16.0f);
		setTexSize(256.0f, 256.0f);
		int w, h;
		getWindowSize(&w, &h);
		
		int numOffset = 1;
		if(game->player.score != 0)
			numOffset = ((int)log10((double)(game->player.score > 0 ? game->player.score : -game->player.score)) + 1);
		float textX = (float)w / 2.0f - numOffset * 16.0f - 8.0f - (float)sizeof("Score:") * 16.0f / 2.0f - 32.0f,
			  textY = (float)h / 2.0f - 32.0f;
		float stringEndX = drawString("Score:", textX, textY, 16.0f); 
		drawInteger(game->player.score, stringEndX - 16.0f + 8.0f * numOffset, textY, 16.0f);
		
		numOffset = 1;
		if(game->waveNum != 0)
			numOffset = ((int)log10((double)(game->waveNum > 0 ? game->waveNum : -game->waveNum)) + 1);

		textX = (float)w / 2.0f - numOffset * 16.0f - 8.0f - (float)sizeof("Wave:") * 16.0f / 2.0f - 32.0f;
		textY -= 24.0f;
		stringEndX = drawString("Wave:", textX, textY, 16.0f);
		drawInteger(game->waveNum, stringEndX - 16.0f + 8.0f * numOffset, textY, 16.0f);	
	}

	outputGLErrors();
	destroyGameObjectPointerList(&game->toDraw);
	game->toDraw = createGameObjectPointerList();
}
