ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

ifeq ($(strip $(BUILD_ROOT)),)
  $(error Need BUILD_ROOT)
endif

include $(BUILD_ROOT)/deps/deps.mk

CMAKE_FLAGS := -DLLVM_PATH='$(LLVM_PATH)' -DCMAKE_CXX_FLAGS=-fno-rtti

default: build
	echo Ahoj

$(BUILD_DIR)/CMakeCache.txt:
	@echo Configuring
	@cmake $(CMAKE_FLAGS) -B'$(BUILD_DIR)' -H./src

build: $(BUILD_DIR)/CMakeCache.txt
	@echo Building
	@cmake --build '$(BUILD_DIR)'
