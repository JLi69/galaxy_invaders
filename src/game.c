#include "game.h"
#include "gettimeofday.h"
#include "window-func.h"
#include "gl-func.h"
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include "draw.h"

#include <stdio.h>

void init(void)
{	
	initGL();
}

void loop(void)
{
	loadTexture("res/images/icons.png"),
	loadTexture("res/images/spaceship.png"),
	loadTexture("res/images/bullet.png");
	loadTexture("res/images/space_jellyfish.png");

	double timepassed = 0.0;
	
	struct GameObject player = createObj(pt(0.0f, -300.0f), pt(0.0f, 0.0f), pt(SPRITE_SIZE, SPRITE_SIZE),
										 4, getImageId("res/images/spaceship.png"));
	struct GameObjectList bullets = createGameObjectList();
	struct GameObjectList enemies = createGameObjectList();
	struct GameObjectList visualEffects = createGameObjectList();

	for(int i = 0; i < 5; i++)
	{
		for(int j = -4; j <= 4; j++)
		{
			appendGameobject(&enemies, createObj(pt(j * (SPRITE_SIZE * 1.5f), 300.0f - i * SPRITE_SIZE), 
						pt(32.0f, 0.0f), pt(SPRITE_SIZE, SPRITE_SIZE), 4, 
						getImageId("res/images/space_jellyfish.png")));
		}	
	}

	while(!canQuit())
	{
		struct timeval start;
		gettimeofday(&start, 0);
		
		display(player, bullets, enemies, visualEffects);
		update(&player, &bullets, &enemies, &visualEffects, timepassed); 

		updateWindow();
		struct timeval end;
		gettimeofday(&end, 0);	
		timepassed = end.tv_sec - start.tv_sec + 1e-6 * (end.tv_usec - start.tv_usec);
	}

	//Clean up
	destroyGameObjectList(&bullets);
	destroyGameObjectList(&enemies);
	destroyGameObjectList(&visualEffects);
}
