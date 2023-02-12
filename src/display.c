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

	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

void display(struct GameObject player,
			 struct GameObjectList bullets,
			 struct GameObjectList enemies, 
			 struct GameObjectList visualEffects
			 )
{
	clear();

	updateActiveShaderWindowSize();
	
	//Draw bullet
	unsigned int prevTexture = -1;
	for(int i = 0; i < bullets.size; i++)
	{
		if(bullets.gameobjects[i].image != prevTexture)
		{
			bindTexture(bullets.gameobjects[i].image, GL_TEXTURE0);
			prevTexture = bullets.gameobjects[i].image;	
		}
		setTextureForObj(bullets.gameobjects[i], 32.0f, 16.0f, 1.0f / 2.0f, 1.0f, 0.0f, 0.0f);
		drawGameObject(bullets.gameobjects[i]);
	}

	for(int i = 0; i < enemies.size; i++)
	{
		if(enemies.gameobjects[i].image != prevTexture)
		{
			bindTexture(enemies.gameobjects[i].image, GL_TEXTURE0);
			prevTexture = enemies.gameobjects[i].image;	
		}
		setTextureForObj(enemies.gameobjects[i], 64.0f, 16.0f, 1.0f / 4.0f, 1.0f, 0.0f, 0.0f);
		drawGameObject(enemies.gameobjects[i]);
	}

	for(int i = 0; i < visualEffects.size; i++)
	{
		if(visualEffects.gameobjects[i].image != prevTexture)
		{
			bindTexture(visualEffects.gameobjects[i].image, GL_TEXTURE0);
			prevTexture = visualEffects.gameobjects[i].image;	
		}
		setTextureForObj(visualEffects.gameobjects[i], 256.0f, 256.0f, 
						 1.0f / 16.0f, 1.0f / 16.0f, 1.0f / 16.0f, 0.0f);
		drawGameObject(visualEffects.gameobjects[i]);
	}

	//Draw player
	bindTexture(player.image, GL_TEXTURE0);
	setTextureForObj(player, 64.0f, 16.0f, 1.0f / 4.0f, 1.0f, 0.0f, 0.0f);	
	drawGameObject(player);	



	outputGLErrors();	
}
