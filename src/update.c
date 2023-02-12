#include "game.h"
#include <GLFW/glfw3.h>
#include "window-func.h"
#include "gl-func.h"

#define ANIMATION_SPEED 0.1f
#define SHOOT_COOLDOWN 0.5f

void update(struct GameObject *player,
			struct GameObjectList *bullets,
			struct GameObjectList *enemies,
			struct GameObjectList *visualEffects,
			float timePassed)
{
	static float animationTimer = 0.0f;
	static float shootTimer = 0.0f;

	//Move gameobjects
	for(int i = 0; i < bullets->size; i++)
		moveObject(&bullets->gameobjects[i], timePassed);	
	for(int i = 0; i < enemies->size; i++)
	{
		if(enemies->gameobjects[i].pos.x > 300.0f ||
		   enemies->gameobjects[i].pos.x < -300.0f)
			enemies->gameobjects[i].vel.x *= -1.0f;
		if(enemies->gameobjects[i].pos.x > 300.0f)
			enemies->gameobjects[i].pos.x = 300.0f;
		if(enemies->gameobjects[i].pos.x < -300.0f)
			enemies->gameobjects[i].pos.x = -300.0f;
		moveObject(&enemies->gameobjects[i], timePassed);
	}

	for(int i = 0; i < bullets->size; i++)
	{
		if(bullets->gameobjects[i].pos.x < -1024.0f ||
		   bullets->gameobjects[i].pos.y < -1024.0f ||
		   bullets->gameobjects[i].pos.x > 1024.0f ||
		   bullets->gameobjects[i].pos.y > 1024.0f)
		{
			deleteGameObject(bullets, i);	
			i--;
			continue;
		}

		for(int j = 0; j < enemies->size; j++)
		{
			if(colliding(enemies->gameobjects[j], bullets->gameobjects[i]))
			{
				appendGameobject(visualEffects, createObj(enemies->gameobjects[j].pos, 
						pt(0.0f, 0.0f), pt(SPRITE_SIZE, SPRITE_SIZE), 4, 
						getImageId("res/images/icons.png")));
				deleteGameObject(enemies, j);
				j--;
				deleteGameObject(bullets, i);
				i--;	
				break;
			}
		}
	}

	moveObject(player, timePassed);
	//Bound the player's position
	if(player->pos.x > 300.0f)
		player->pos.x = 300.0f;
	if(player->pos.x < -300.0f)
		player->pos.x = -300.0f;
	if(player->pos.y > 300.0f)
		player->pos.y = 300.0f;
	if(player->pos.y < -300.0f)
		player->pos.y = -300.0f;

	//Delete objects

	//Keyboard movement
	if(isPressed(GLFW_KEY_LEFT)) player->vel.x = -SPEED;
	else if(isPressed(GLFW_KEY_RIGHT)) player->vel.x = SPEED;
	else player->vel.x = 0.0f;

	if(isPressed(GLFW_KEY_DOWN)) player->vel.y = -SPEED;
	else if(isPressed(GLFW_KEY_UP)) player->vel.y = SPEED;
	else player->vel.y = 0.0f;

	//Shoot!
	if(isPressed(GLFW_KEY_SPACE) && shootTimer <= 0.0f)  
	{	
		float velY = player->vel.y > 0.0 ? player->vel.y : 0.0f;
		appendGameobject(
					 bullets, 
					 createObj(player->pos, 
							   pt(player->vel.x, BULLET_SPEED + velY),
							   pt(SPRITE_SIZE, SPRITE_SIZE), 2, 
							   getImageId("res/images/bullet.png")));
		shootTimer = SHOOT_COOLDOWN;
	}

	animationTimer += timePassed;
	shootTimer -= timePassed;

	//Animate objects
	if(animationTimer > 0.1f)
	{
		animateObject(player);
		
		for(int i = 0; i < bullets->size; i++)
			animateObject(&bullets->gameobjects[i]);
		for(int i = 0; i < enemies->size; i++)
			animateObject(&enemies->gameobjects[i]);

		for(int i = 0; i < visualEffects->size; i++)
		{
			animateObject(&visualEffects->gameobjects[i]);
			if(visualEffects->gameobjects[i].animationFrame ==
			   visualEffects->gameobjects[i].totalFrames - 1)
			{
				deleteGameObject(visualEffects, i);
				i--;
			}
		}	

		animationTimer = 0.0f;
	}
}
