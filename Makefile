#TODO: add support for building with MinGW

BIN=galaxy_invaders
CC=cc
BUILD_DIR=./obj
SRC=$(wildcard src/*.c)
OBJ=$(SRC:%=$(BUILD_DIR)/%.o)

GLAD=gllibs/lib/glad.c

C_FLAGS=-O1
LD_FLAGS_LINUX=-static-libgcc -lglfw3 -lm -lGL
INCLUDE=-Igllibs/include
LINK_DIR_LINUX=-Lgllibs/lib/linux
LINK_DIR_MINGW=-Lgllibs/lib/mingw

output: $(OBJ)
	$(CC) $(OBJ) $(GLAD) -o $(BIN) $(LD_FLAGS_LINUX)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

$(BUILD_DIR)/%.c.o: %.c $(BUILD_DIR)
	mkdir -p $(dir $@)
	$(CC) $(C_FLAGS) -c $< -o $@ $(INCLUDE) $(LINK_DIR_LINUX)

clean:
	rm -rf $(BUILD_DIR) $(BIN)

run:
	./$(BIN)
