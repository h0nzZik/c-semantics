include ../inc.mk

CMAKE_FLAGS := -DLLVM_PATH='$(LLVM_PATH)' -DCMAKE_CXX_FLAGS=-fno-rtti

.PHONY: default
default: build

$(B)/CMakeCache.txt:
	@$(GENERATING)
	@cmake $(CMAKE_FLAGS) -B'$(B)' -H./src

.PHONY: build
build: $(B)/CMakeCache.txt
	@echo Building
	@cmake --build '$(B)'
