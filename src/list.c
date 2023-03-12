#include "gameobject.h"
#include <stdlib.h>

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
	free(list->gameobjects[list->size - 1].scriptname);
	list->gameobjects[list->size - 1].scriptname = NULL;
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

struct GameObjectPointerList createGameObjectPointerList()
{
	struct GameObjectPointerList list;
	list.pointers = (struct GameObject**)malloc(sizeof(void*) * DEFAULT_MAX_SZ);
	list.size = 0;
	list._maxSize = DEFAULT_MAX_SZ;
	return list;
}

void appendGameobjectPointer(struct GameObjectPointerList *list, struct GameObject *object)
{
	if(list->size < list->_maxSize)
		list->pointers[list->size++] = object;
	else
	{
		list->_maxSize *= 2;
		list->pointers = realloc(list->pointers, list->_maxSize * sizeof(void*));
		list->pointers[list->size++] = object;
	}
}

void deleteGameObjectPointer(struct GameObjectPointerList *list, int index)
{
	if(index >= list->size)
		return;
	struct GameObject* temp = list->pointers[list->size - 1];
	list->pointers[list->size - 1] = list->pointers[index];
	list->pointers[index] = temp;
	list->size--;

	if(list->size * 2 < list->_maxSize && list->_maxSize > DEFAULT_MAX_SZ)
	{
		list->_maxSize /= 2;
		list->pointers = realloc(list->pointers, list->_maxSize * sizeof(void*));
	}
}

void destroyGameObjectPointerList(struct GameObjectPointerList *list)
{
	free(list->pointers);
	list->size = 0;
	list->_maxSize = 0;
	list->pointers = NULL;
}
