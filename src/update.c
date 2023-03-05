#include "game.h"
#include <GLFW/glfw3.h>
#include "window-func.h"
#include "gl-func.h"

#include <stdio.h>

#define ANIMATION_SPEED 0.1f
#define SHOOT_COOLDOWN 0.5f

void update(struct Game *game,
			float timePassed,
			lua_State *L)
{
	static float animationTimer = 0.0f;
	static float shootTimer = 0.0f;

	//Move gameobjects
	for(int i = 0; i < game->bullets.size; i++)
		runUpdateFunction(L, game->bullets.gameobjects[i].scriptname, &game->bullets.gameobjects[i], game, timePassed);
	for(int i = 0; i < game->enemies.size; i++)
		runUpdateFunction(L, game->enemies.gameobjects[i].scriptname, &game->enemies.gameobjects[i], game, timePassed);

	for(int i = 0; i < game->bullets.size; i++)
	{
		if(game->bullets.gameobjects[i].pos.x < -1024.0f ||
		   game->bullets.gameobjects[i].pos.y < -1024.0f ||
		   game->bullets.gameobjects[i].pos.x > 1024.0f ||
		   game->bullets.gameobjects[i].pos.y > 1024.0f)
		{
			deleteGameObject(&game->bullets, i);	
			i--;
			continue;
		}

		for(int j = 0; j < game->enemies.size; j++) {
			if(colliding(game->enemies.gameobjects[j], game->bullets.gameobjects[i]))
			{
				if(runOnCollisionFunction(L, game->enemies.gameobjects[i].scriptname, &game->enemies.gameobjects[j], game))
				{
					deleteGameObject(&game->enemies, j);
					j--;
				}

				deleteGameObject(&game->bullets, i);
				i--;
				break;
			}
		}
	}

	runUpdateFunction(L, game->player.scriptname, &game->player, game, timePassed);

	//Keyboard movement
	if(isPressed(GLFW_KEY_LEFT)) game->player.vel.x = -SPEED;
	else if(isPressed(GLFW_KEY_RIGHT)) game->player.vel.x = SPEED;
	else game->player.vel.x = 0.0f;

	if(isPressed(GLFW_KEY_DOWN)) game->player.vel.y = -SPEED;
	else if(isPressed(GLFW_KEY_UP)) game->player.vel.y = SPEED;
	else game->player.vel.y = 0.0f;

	//Shoot!
	if(isPressed(GLFW_KEY_SPACE) && shootTimer <= 0.0f)  
	{	
		appendGameobject(
					 &game->bullets, 
					 createObj(game->player.pos, 
							   pt(0.0f, BULLET_SPEED),
							   pt(SPRITE_SIZE, SPRITE_SIZE), 2, 
							   getImageId("res/images/bullet.png"), "bullet"));
		shootTimer = SHOOT_COOLDOWN;
	}

	animationTimer += timePassed;
	shootTimer -= timePassed;

	//Animate objects
	if(animationTimer > 0.2f)
	{
		animateObject(&game->player);
		
		for(int i = 0; i < game->bullets.size; i++)
			animateObject(&game->bullets.gameobjects[i]);
		for(int i = 0; i < game->enemies.size; i++)
			animateObject(&game->enemies.gameobjects[i]);

		for(int i = 0; i < game->visualEffects.size; i++)
		{
			animateObject(&game->visualEffects.gameobjects[i]);
			if(game->visualEffects.gameobjects[i].animationFrame >=
			   game->visualEffects.gameobjects[i].totalFrames - 1)
			{
				deleteGameObject(&game->visualEffects, i);
				i--;
			}
		}	

		animationTimer = 0.0f;
	}
}
