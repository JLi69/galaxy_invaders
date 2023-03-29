#include "gameobject.h"
#include "draw.h"
#include <stdlib.h>
#include <string.h>

void animateObject(struct GameObject *obj)
{
	if(obj->totalFrames <= 0)
		return;
	obj->animationFrame++;
	obj->animationFrame %= obj->totalFrames;
}

struct GameObject createObj(Vector2f pos,
							Vector2f vel,
							Vector2f dim,
							int maxFrames,
							unsigned int img,
							const char *scriptname)
{
	struct GameObject obj = 
		{ .pos = pos,
		  .vel = vel,
		  .dim = dim,
		  .rotation = 0.0f,
		  .rotationSpeed = 0.0f,
		  .animationFrame = 0,
		  .totalFrames = maxFrames,
		  .image = img,
		  .timer = 0.0,
		  .health = 0,
		  .mode = 0,
		  .score = 0,
		  .z = 0,
		  .scriptname = NULL };
	
	setGameobjectScript(&obj, scriptname);
	return obj;
}

Vector2f pt(float x, float y)
{
	Vector2f v =
		{
			.x = x,
			.y = y
		};
	return v;
}

void setTextureForObj(struct GameObject obj,
					  float w, float h,
					  float fracX, float fracY,
					  float x, float y)
{
	setTexSize(w, h);
	setTexFrac(fracX, fracY);
	//Number of images per row in the spritesheet
	int perRow = (int)(1.0f / fracX);
	setTexOffset(x + fracX * (float)(obj.animationFrame % perRow), 
				 y + fracY * (float)(obj.animationFrame / perRow));
}

void drawGameObject(struct GameObject obj)
{
	if(obj.image == 0)
		return;
	setRectPos(obj.pos.x, obj.pos.y);
	setRectSize(obj.dim.x, obj.dim.y);
	drawRect();
}

int colliding(struct GameObject object1, struct GameObject object2)
{
	return object1.pos.x - object1.dim.x / 2.0f < object2.pos.x + object2.dim.x / 2.0f && 
		   object2.pos.x - object2.dim.x / 2.0f < object1.pos.x + object1.dim.x / 2.0f &&
		   object1.pos.y - object1.dim.y / 2.0f < object2.pos.y + object2.dim.y / 2.0f && 
		   object2.pos.y - object2.dim.y / 2.0f < object1.pos.y + object1.dim.y / 2.0f;
}

void setGameobjectScript(struct GameObject *obj, const char *scriptname)
{
	if(scriptname == NULL)
	{
		obj->scriptname = NULL;
		return;	
	}

	if(obj->scriptname != NULL)
		free(obj->scriptname);

	obj->scriptname = (char*)malloc(strlen(scriptname) + 1);
	strncpy(obj->scriptname, scriptname, strlen(scriptname));
	obj->scriptname[strlen(scriptname)] = '\0';
}
