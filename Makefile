# Compiler
CXX := g++

# Compiler flags
CXXFLAGS := -std=c++20 -Wall -Wextra -pedantic

# Directories
SRC_DIR := src
INC_DIR := src/inc
LIB_DIR := src/lib
BUILD_DIR := build
OUT_DIR := out
OPENXLSX_DIR := external/OpenXLSX
TEST_DIR := tests
TEST_BUILD_DIR := $(BUILD_DIR)/tests
GTEST_DIR := external/googletest
GTEST_BUILD_DIR := $(BUILD_DIR)/gtest
GTEST_LIB := $(GTEST_BUILD_DIR)/lib/libgtest.a
GTEST_MAIN_LIB := $(GTEST_BUILD_DIR)/lib/libgtest_main.a

# OpenXLSX
OPENXLSX_BUILD_DIR := $(BUILD_DIR)/OpenXLSX
OPENXLSX_LIB := $(OPENXLSX_BUILD_DIR)/output/libOpenXLSX.a
CXXFLAGS += -I$(OPENXLSX_DIR)/include
LDFLAGS += -L$(OPENXLSX_BUILD_DIR)/OpenXLSX

# Add include path for gtest
CXXFLAGS += -I$(GTEST_DIR)/googletest/include

# Source files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
SRCS_NO_MAIN := $(filter-out $(SRC_DIR)/main.cpp, $(SRCS))

# Object files
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRCS))
OBJS_NO_MAIN := $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(SRCS_NO_MAIN))

# Test sources and objects
TEST_SRCS := $(wildcard $(TEST_DIR)/*.cpp)
TEST_OBJS := $(patsubst $(TEST_DIR)/%.cpp,$(TEST_BUILD_DIR)/%.o,$(TEST_SRCS))

# Executable names
EXEC := $(OUT_DIR)/program
TEST_EXEC := $(OUT_DIR)/run_tests

# Targets
all: $(EXEC)

$(EXEC): $(OBJS) $(OPENXLSX_LIB) | $(OUT_DIR)
	$(CXX) $(CXXFLAGS) $(OBJS) $(OPENXLSX_LIB) -o $@ $(LDFLAGS) $(LDLIBS)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $@

$(OUT_DIR):
	mkdir -p $@

$(OPENXLSX_LIB): | $(OPENXLSX_BUILD_DIR)
	cd $(OPENXLSX_BUILD_DIR) && cmake $(CURDIR)/$(OPENXLSX_DIR) -DCMAKE_BUILD_TYPE=Release -DOPENXLSX_BUILD_SAMPLES=OFF -DOPENXLSX_BUILD_TESTS=OFF
	$(MAKE) -C $(OPENXLSX_BUILD_DIR)

$(OPENXLSX_BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR) $(OUT_DIR)

.PHONY: all clean

# Dependencies
-include $(OBJS:.o=.d)

# Generate dependency files
$(BUILD_DIR)/%.d: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	@$(CXX) $(CXXFLAGS) -MM -MT $(@:.d=.o) $< > $@

# Run the program
run: $(EXEC)
	./$(EXEC)

.PHONY: test
test: $(TEST_EXEC)
	./$(TEST_EXEC)

# Rule to build gtest
$(GTEST_LIB):
	mkdir -p $(GTEST_BUILD_DIR)
	cd $(GTEST_BUILD_DIR) && cmake $(CURDIR)/$(GTEST_DIR) -DCMAKE_BUILD_TYPE=Release
	$(MAKE) -C $(GTEST_BUILD_DIR)

# Rule to build test executable
$(TEST_EXEC): $(TEST_OBJS) $(OBJS_NO_MAIN) $(GTEST_LIB) $(GTEST_MAIN_LIB) $(OPENXLSX_LIB) | $(OUT_DIR)
	$(CXX) $(CXXFLAGS) $(TEST_OBJS) $(OBJS_NO_MAIN) -o $@ $(LDFLAGS) $(GTEST_LIB) $(GTEST_MAIN_LIB) $(OPENXLSX_LIB) $(LDLIBS) -lpthread

# Rule to compile test source files
$(TEST_BUILD_DIR)/%.o: $(TEST_DIR)/%.cpp | $(TEST_BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(TEST_BUILD_DIR):
	mkdir -p $@

# Add test cleaning to the clean target
clean: clean_tests

.PHONY: clean_tests
clean_tests:
	rm -rf $(TEST_BUILD_DIR) $(TEST_EXEC)

