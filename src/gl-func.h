#ifndef GL_FUNC_H
//Maximum shader size of 8KB
#define MAX_SRC_LEN 8192
#define MAX_LOG_LEN 1024
#define MAX_UNIFORM_LEN 128
#define EMPTY_SHADER -1

struct Uniform
{
	char name[MAX_UNIFORM_LEN + 1];
	int location;
};

struct Image
{
	char path[256];
	unsigned int id;
};

struct ImageList
{
	struct Image *images;
	unsigned int _imageCount;
	unsigned int _maxImageCount;
};

struct ShaderProgram
{
	unsigned int id;
	struct Uniform* uniforms;
	unsigned int _uniformCount;
	unsigned int _maxUniformCount;
};

struct Buffers
{
	unsigned int arr;
	
	unsigned int* buffers;
	unsigned int *types,
				 *vertSize,
				 *vertElementCount;

	unsigned int bufferCount;
};

//Shader utility functions
void readShaderFile(const char *path, char *output, unsigned int maxSize);
void outputCompileErrors(unsigned int shader);
struct ShaderProgram createShaderProgram(const char *vertpath, const char *fragpath);
void cleanupProgram(struct ShaderProgram *program);
//Uniforms
//If it finds the uniform in the list of uniforms, it will return the location
//Otherwise it will add the location to the list and then return that value
int getUniformLocation(const char *uniformName, struct ShaderProgram *program);

void outputGLErrors(void);

struct Buffers createRectangleBuffer(void);
void bindBuffers(struct Buffers buff);
void cleanupBuffer(struct Buffers buff);

void useShader(struct ShaderProgram *shaderPtr);
//Returns pointer to the current active shader
struct ShaderProgram* getActiveShader(void);

//textures
void appendImageId(const char *path, unsigned int id);
unsigned int loadTexture(const char *path); 
void bindTexture(unsigned int texture, int texBinding);
unsigned int getImageId(const char *path); //Assumes that the image has already been loaded,
										   //Will return 0 otherwise

void cleanupImages(void);

#endif
#define GL_FUNC_H
