#ifndef GAMEBOJECT_H

#define DEFAULT_MAX_SZ 64

typedef struct 
{
	float x, y;
} Vector2f;

struct GameObject
{
	Vector2f pos, vel, dim; 
	int animationFrame, totalFrames;
	unsigned int image;
};

struct GameObjectList
{
	struct GameObject *gameobjects;
	unsigned long long size, _maxSize;
};

struct GameObject createObj(Vector2f pos, Vector2f vel, Vector2f dim, int maxFrames, 
							unsigned int img);
void moveObject(struct GameObject *obj, float timePassed);
void animateObject(struct GameObject *obj);
void setTextureForObj(struct GameObject obj, 
					  float w, float h,
					  float fracX, float fracY,
					  float x, float y);
void drawGameObject(struct GameObject obj);
Vector2f pt(float x, float y);

struct GameObjectList createGameObjectList();
void appendGameobject(struct GameObjectList *list, struct GameObject object);
void deleteGameObject(struct GameObjectList *list, int index);
void destroyGameObjectList(struct GameObjectList *list);

int colliding(struct GameObject object1, struct GameObject object2);

#endif
