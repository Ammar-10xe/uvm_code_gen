
CC = gcc
CFLAGS = -Wall -Wextra -std=c99

SRC = uvm_gen.c

TARGET = uvm_gen

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

run: all
	@echo "Running the UVM generator..."
	@./$(TARGET)

clean:
	@echo "Cleaning up generated files and directories..."
	@rm -f $(TARGET)
	@rm -rf output

.PHONY: all run clean
