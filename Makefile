# Makefile - C11 server/client project
CC = gcc
CFLAGS = -std=c11 -Wall -Wextra -pedantic -g
LDFLAGS =
SRC_DIR = src
BUILD_DIR = build
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))
TARGET_SERVER = server
TARGET_CLIENT = client

.PHONY: all clean run-server run-client test

all: $(BUILD_DIR) $(TARGET_SERVER) $(TARGET_CLIENT)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -I$(SRC_DIR) -c $< -o $@

$(TARGET_SERVER): $(BUILD_DIR)/server.o $(BUILD_DIR)/network.o $(BUILD_DIR)/session.o $(BUILD_DIR)/transfer.o $(BUILD_DIR)/utils.o $(BUILD_DIR)/ipc.o
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

$(TARGET_CLIENT): $(BUILD_DIR)/client.o $(BUILD_DIR)/network.o $(BUILD_DIR)/utils.o $(BUILD_DIR)/transfer.o
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

run-server: all
	./$(TARGET_SERVER) --ip 127.0.0.1 --port 8080

run-client: all
	./$(TARGET_CLIENT) --server 127.0.0.1 --port 8080

clean:
	rm -rf $(BUILD_DIR) $(TARGET_SERVER) $(TARGET_CLIENT)

test: all
	tests/simple_network_test.sh 127.0.0.1 8080
