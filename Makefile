BIN=galaxy_invaders
CC=cc
BUILD_DIR=./obj
SRC_DIRS=src
SRC=$(wildcard src/*.c)
HEADER=$(wildcard src/*.h)
OBJ=$(SRC:%=$(BUILD_DIR)/%.o)
BUILD_SRC_DIRS=$(SRC_DIRS:%=$(BUILD_DIR)/%)

GLAD=glad/glad.c

C_FLAGS=-O2
LD_FLAGS_LINUX=-static-libgcc -lglfw3 -lm -lSOIL2 -lGL -llua 
LD_FLAGS_MINGW=-static-libgcc -lglfw3 -lm -lSOIL2 -llua -lopengl32 -lgdi32 -Wl,-Bstatic,--whole-archive -lwinpthread -Wl,-Bdynamic,--no-whole-archive -mwindows 
INCLUDE=-Iglad/include -Ilua/include
LD_FLAGS=

ifeq ($(OS), Windows_NT)
# on windows
# assuming mingw is installed
CC=gcc
LD_FLAGS=$(LD_FLAGS_MINGW)
OBJ+=galaxy_invaders.res
else
# on linux
LD_FLAGS=$(LD_FLAGS_LINUX)
endif

output: $(OBJ)
	$(CC) $(OBJ) $(GLAD) -o $(BIN) $(LD_FLAGS) $(INCLUDE)

galaxy_invaders.res: galaxy_invaders.rc
	windres galaxy_invaders.rc -O coff -o galaxy_invaders.res

$(BUILD_DIR): $(BUILD_SRC_DIRS)

$(BUILD_DIR)/%.c.o: %.c $(BUILD_DIR) $(HEADER) 
	$(CC) $(C_FLAGS) -c $< -o $@ $(INCLUDE)

$(BUILD_SRC_DIRS): 
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR) $(BIN)

run:
	./$(BIN)
