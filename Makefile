#TODO: add support for building with MinGW

BIN=galaxy_invaders
CC=cc
BUILD_DIR=./obj
SRC_DIRS=src
SRC=$(wildcard src/*.c)
HEADER=$(wildcard src/*.h)
OBJ=$(SRC:%=$(BUILD_DIR)/%.o)
BUILD_SRC_DIRS=$(SRC_DIRS:%=$(BUILD_DIR)/%)

GLAD=gllibs/lib/glad.c

C_FLAGS=-O0
LD_FLAGS_LINUX=-static-libgcc -lglfw3 -lm -lSOIL2 -lGL -llua 
INCLUDE=-Igllibs/include -Iliblua/include
LINK_DIR_LINUX=-Lgllibs/lib/linux -Lliblua
LINK_DIR_MINGW=-Lgllibs/lib/mingw -Lliblua

output: $(OBJ)
	$(CC) $(OBJ) $(GLAD) -o $(BIN) $(LD_FLAGS_LINUX)

$(BUILD_DIR): $(BUILD_SRC_DIRS)

$(BUILD_DIR)/%.c.o: %.c $(BUILD_DIR) $(HEADER) 
	$(CC) $(C_FLAGS) -c $< -o $@ $(INCLUDE) $(LINK_DIR_LINUX)

$(BUILD_SRC_DIRS): 
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR) $(BIN)

run:
	./$(BIN)
