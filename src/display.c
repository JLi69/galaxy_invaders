#include "game.h"
#include "draw.h"
#include "gl-func.h"
#include <glad/glad.h>
#include "window-func.h"

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

	loadTexture("res/images/icons.png"),
	loadTexture("res/images/spaceship.png"),

	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

void display(struct Game game)
{
	clear();

	updateActiveShaderWindowSize();
	
	//Draw bullet
	unsigned int prevTexture = -1;
	for(int i = 0; i < game.bullets.size; i++)
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
	drawGameObject(game.player);	

	if(isPaused())
	{
		setTexFrac(1.0f / 16.0f, 1.0f / 16.0f);
		setTexSize(256.0f, 256.0f);
		bindTexture(getImageId("res/images/icons.png"), GL_TEXTURE0);
		drawString("Paused", 0.0f, 0.0f, 64.0f);
	}

	outputGLErrors();	
}
