#include <stdio.h>
#define GLFW_INCLUDE_NONE
#include <GLFW/glfw3.h>
#include <glad/glad.h>

int main(void)
{
	if(!glfwInit())
	{
		fprintf(stderr, "Failed to initialize GLFW\n");
		return -1;	
	}

	//Create window
	GLFWwindow* win = glfwCreateWindow(640, 480, "Galaxy Invaders", NULL, NULL);
	if(!win)
	{
		fprintf(stderr, "Failed to create window\n");
		glfwTerminate();
		return -1;
	}
	glfwMakeContextCurrent(win);

	//Load glad
	if(!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		fprintf(stderr, "Failed to load glad\n");
		glfwTerminate();
		return -1;
	}

	//Main loop
	while(!glfwWindowShouldClose(win))
	{
		glClear(GL_COLOR_BUFFER_BIT);
		glfwSwapBuffers(win);
		glfwPollEvents();
	}

	glfwTerminate();
}
