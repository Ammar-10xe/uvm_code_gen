# Name of the Python script
SCRIPT = main.py

# Target directory for output
OUTPUT_DIR = output

# Default target
all: clean run

# Clean the output directory
clean:
	@echo "Cleaning output directory..."
	@rm -rf $(OUTPUT_DIR)/*
	@mkdir -p $(OUTPUT_DIR)

# Run the Python script
run:
	@echo "Generating UVM code..."
	@python3 $(SCRIPT)
