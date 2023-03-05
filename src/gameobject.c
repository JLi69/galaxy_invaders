#include "gameobject.h"
#include "draw.h"
#include <stdlib.h>

void moveObject(struct GameObject *obj, float timePassed)
{
	obj->pos.x += obj->vel.x * timePassed;
	obj->pos.y += obj->vel.y * timePassed;
}

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
							unsigned int img)
{
	struct GameObject obj = 
		{ .pos = pos,
		  .vel = vel,
		  .dim = dim,
		  .animationFrame = 0,
		  .totalFrames = maxFrames,
		  .image = img,
		  .timer = 0.0,
		  .health = 0 };
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
	setRectPos(obj.pos.x, obj.pos.y);
	setRectSize(obj.dim.x, obj.dim.y);
	drawRect();
}

struct GameObjectList createGameObjectList()
{
	struct GameObjectList list;
	list.gameobjects = (struct GameObject*)malloc(sizeof(struct GameObject) * DEFAULT_MAX_SZ);
	list.size = 0;
	list._maxSize = DEFAULT_MAX_SZ;
	return list;
}

void appendGameobject(struct GameObjectList *list, struct GameObject object)
{
	if(list->size < list->_maxSize)
		list->gameobjects[list->size++] = object;
	else
	{
		list->_maxSize *= 2;
		list->gameobjects = realloc(list->gameobjects, list->_maxSize * sizeof(struct GameObject));
		list->gameobjects[list->size++] = object;
	}
}

void deleteGameObject(struct GameObjectList *list, int index)
{
	if(index >= list->size)
		return;
	struct GameObject temp = list->gameobjects[list->size - 1];
	list->gameobjects[list->size - 1] = list->gameobjects[index];
	list->gameobjects[index] = temp;
	list->size--;

	if(list->size * 2 < list->_maxSize && list->_maxSize > DEFAULT_MAX_SZ)
	{
		list->_maxSize /= 2;
		list->gameobjects = realloc(list->gameobjects, list->_maxSize * sizeof(struct GameObject));
	}
}

void destroyGameObjectList(struct GameObjectList *list)
{
	free(list->gameobjects);
	list->gameobjects = NULL;
	list->size = 0;
	list->_maxSize = 0;
}

int colliding(struct GameObject object1, struct GameObject object2)
{
	return object1.pos.x - object1.dim.x / 2.0f < object2.pos.x + object2.dim.x / 2.0f && 
		   object2.pos.x - object2.dim.x / 2.0f < object1.pos.x + object1.dim.x / 2.0f &&
		   object1.pos.y - object1.dim.y / 2.0f < object2.pos.y + object2.dim.y / 2.0f && 
		   object2.pos.y - object2.dim.y / 2.0f < object1.pos.y + object1.dim.y / 2.0f;
}
