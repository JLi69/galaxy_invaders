BIN=galaxy_invaders
CC=cc
BUILD_DIR=./obj
SRC_DIRS=src
SRC=$(wildcard src/*.c)
HEADER=$(wildcard src/*.h)
OBJ=$(SRC:%=$(BUILD_DIR)/%.o)
BUILD_SRC_DIRS=$(SRC_DIRS:%=$(BUILD_DIR)/%)

GLAD=gllibs/lib/glad.c

C_FLAGS=-O2 -g
LD_FLAGS_LINUX=-static-libgcc -lglfw3 -lm -lSOIL2 -lGL -llua 
LD_FLAGS_MINGW=-static-libgcc -lglfw3 -lm -lSOIL2 -llua -lopengl32 -lgdi32 -Wl,-Bstatic,--whole-archive -lwinpthread -Wl,-Bdynamic,--no-whole-archive -mwindows
INCLUDE=-Igllibs/include -Iliblua/include
LINK_DIR_LINUX=-Lgllibs/lib/linux -Lliblua/linux
LINK_DIR_MINGW=-Lgllibs/lib/mingw -Lliblua/windows
LINK_DIR=
LD_FLAGS=

ifeq ($(OS), Windows_NT)
# on windows
# assuming mingw is installed
CC=gcc
LINK_DIR=$(LINK_DIR_MINGW)
LD_FLAGS=$(LD_FLAGS_MINGW)
else
# on linux
LINK_DIR=$(LINK_DIR_LINUX)
LD_FLAGS=$(LD_FLAGS_LINUX)
endif

output: $(OBJ)
	$(CC) $(OBJ) $(GLAD) -o $(BIN) $(LINK_DIR) $(LD_FLAGS) $(INCLUDE)

$(BUILD_DIR): $(BUILD_SRC_DIRS)

$(BUILD_DIR)/%.c.o: %.c $(BUILD_DIR) $(HEADER) 
	$(CC) $(C_FLAGS) -c $< -o $@ $(INCLUDE) $(LINK_DIR_LINUX)

$(BUILD_SRC_DIRS): 
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR) $(BIN)

run:
	./$(BIN)
