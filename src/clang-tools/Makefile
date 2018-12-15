ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

ifeq ($(strip $(BUILD_ROOT)),)
  $(error Need BUILD_ROOT)
endif

B := $(BUILD_DIR)

include $(BUILD_ROOT)/deps/deps.mk

CMAKE_FLAGS := -DLLVM_PATH='$(LLVM_PATH)' -DCMAKE_CXX_FLAGS=-fno-rtti

.PHONY: default
default: build

$(B)/CMakeCache.txt:
	@echo Configuring
	@cmake $(CMAKE_FLAGS) -B'$(B)' -H./src

.PHONY: build
build: $(B)/CMakeCache.txt
	@echo Building
	@cmake --build '$(B)'
