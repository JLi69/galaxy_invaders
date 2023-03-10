#include "game.h"
#include <GLFW/glfw3.h>
#include "window-func.h"
#include "gl-func.h"
#include <lauxlib.h>
#include <lualib.h>

#include <stdio.h>

#define ANIMATION_SPEED 0.1f

void update(struct Game *game,
			float timePassed,
			lua_State *L)
{
	static float animationTimer = 0.0f;

	//Move gameobjects
	for(int i = 0; i < game->bullets.size; i++)
		runUpdateFunction(L, game->bullets.gameobjects[i].scriptname, &game->bullets.gameobjects[i], game, timePassed);
	for(int i = 0; i < game->enemies.size; i++)
		runUpdateFunction(L, game->enemies.gameobjects[i].scriptname, &game->enemies.gameobjects[i], game, timePassed);
	for(int i = 0; i < game->visualEffects.size; i++)
		runUpdateFunction(L, game->visualEffects.gameobjects[i].scriptname, &game->visualEffects.gameobjects[i], game, timePassed);

	for(int i = 0; i < game->enemies.size; i++)
	{
		if(game->enemies.gameobjects[i].pos.x < -1024.0f ||
		   game->enemies.gameobjects[i].pos.y < -600.0f ||
		   game->enemies.gameobjects[i].pos.x > 1024.0f ||
		   game->enemies.gameobjects[i].pos.y > 600.0f)
		{
			deleteGameObject(&game->enemies, i);	
			i--;
			continue;
		}
	}

	for(int i = 0; i < game->bullets.size; i++)
	{
		if(game->bullets.gameobjects[i].pos.x < -1024.0f ||
		   game->bullets.gameobjects[i].pos.y < -600.0f ||
		   game->bullets.gameobjects[i].pos.x > 1024.0f ||
		   game->bullets.gameobjects[i].pos.y > 600.0f)
		{
			deleteGameObject(&game->bullets, i);	
			i--;
			continue;
		}

		for(int j = 0; j < game->enemies.size; j++) 
		{
			if(colliding(game->enemies.gameobjects[j], game->bullets.gameobjects[i]))
			{
				game->player.score += game->enemies.gameobjects[j].score;
				if(runOnCollisionFunction(L, game->enemies.gameobjects[j].scriptname, &game->enemies.gameobjects[j], game))
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
	
	//Update the player
	runUpdateFunction(L, game->player.scriptname, &game->player, game, timePassed);
	for(int i = 0; i < game->enemies.size; i++)
	{
		if(colliding(game->enemies.gameobjects[i], game->player))
		{	
			runOnCollisionFunction(L, game->player.scriptname, &game->player, game);
			if(runOnCollisionWithPlayerFunction(L, game->enemies.gameobjects[i].scriptname, &game->enemies.gameobjects[i], game))
			{
				deleteGameObject(&game->enemies, i);
				i--;
			}
		}	
	}

	//Keyboard movement
	if(isPressed(GLFW_KEY_LEFT)) game->player.vel.x = -SPEED;
	else if(isPressed(GLFW_KEY_RIGHT)) game->player.vel.x = SPEED;
	else game->player.vel.x = 0.0f;

	if(isPressed(GLFW_KEY_DOWN)) game->player.vel.y = -SPEED;
	else if(isPressed(GLFW_KEY_UP)) game->player.vel.y = SPEED;
	else game->player.vel.y = 0.0f;

	//Shoot!
	if(isPressed(GLFW_KEY_SPACE) && game->player.timer <= 0.0f && game->player.mode == 0)  
	{	
		appendGameobject(
					 &game->bullets, 
					 createObj(game->player.pos, 
							   pt(0.0f, BULLET_SPEED),
							   pt(SPRITE_SIZE, SPRITE_SIZE), 2, 
							   getImageId("res/images/bullet.png"), "bullet"));
		
		lua_getglobal(L, game->player.scriptname);
		luaL_checktype(L, -1, LUA_TTABLE);
		lua_getfield(L, -1, "SHOOT_COOLDOWN");
		game->player.timer = lua_tonumber(L, -1);
	}

	animationTimer += timePassed;

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
