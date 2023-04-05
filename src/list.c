#include "gameobject.h"
#include <stdlib.h>

#include <stdio.h>

struct GameObjectList createGameObjectList()
{
	struct GameObjectList list;
	list.gameobjects = (struct GameObject*)malloc(sizeof(struct GameObject) * DEFAULT_MAX_SZ);
	list.size = 0;
	list._maxSize = DEFAULT_MAX_SZ;
	
	list.toAdd = (struct GameObject*)malloc(sizeof(struct GameObject) * DEFAULT_MAX_SZ);
	list._toAddCount = 0;
	list._maxToAdd = DEFAULT_MAX_SZ;

	return list;
}

void appendGameobject(struct GameObjectList *list, struct GameObject object)
{
	if(list->size < list->_maxSize)
		list->gameobjects[list->size++] = object;
	else
	{
		list->_maxSize *= 2;
		list->gameobjects = realloc(list->gameobjects, sizeof(struct GameObject) * list->_maxSize); 
		list->gameobjects[list->size++] = object;
	}
}

void deleteGameObject(struct GameObjectList *list, int index)
{
	if(index >= list->size || index < 0)
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
		list->gameobjects = realloc(list->gameobjects, sizeof(struct GameObject) * list->_maxSize); 
	}
}

void destroyGameObjectList(struct GameObjectList *list)
{
	for(int i = 0; i < list->size; i++)
		free(list->gameobjects[i].scriptname);
	free(list->gameobjects);
	list->gameobjects = NULL;
	list->size = 0;
	list->_maxSize = 0;
	
	for(int i = 0; i < list->_toAddCount; i++)
		free(list->toAdd->scriptname);
	free(list->toAdd);
	list->toAdd = NULL;
	list->_toAddCount = 0;
	list->_maxToAdd = 0;
}

void addToList(struct GameObjectList *list, struct GameObject object)
{
	if(list->size == 0 && list->_maxSize != DEFAULT_MAX_SZ)
	{
		free(list->gameobjects);
		*list = createGameObjectList();
		return;	
	}

	if(list->_toAddCount < list->_maxToAdd)
		list->toAdd[list->_toAddCount++] = object;
	else
	{
		list->_maxToAdd *= 2;
		list->toAdd = realloc(list->toAdd, sizeof(struct GameObject) * list->_maxToAdd); 
		list->toAdd[list->_toAddCount++] = object;
	}
}

void addItems(struct GameObjectList *list)
{
	for(int i = 0; i < list->_toAddCount; i++)
		appendGameobject(list, list->toAdd[i]);
	
	if(list->_toAddCount != 0)
	{
		free(list->toAdd);
		list->toAdd = (struct GameObject*)malloc(sizeof(struct GameObject) * DEFAULT_MAX_SZ);
		list->_toAddCount = 0;
		list->_maxToAdd = DEFAULT_MAX_SZ;
	}
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
