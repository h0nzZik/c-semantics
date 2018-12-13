ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif

ifeq ($(strip $(BUILD_ROOT)),)
  $(error Need BUILD_ROOT)
endif

ifeq ($(strip $(PROFILE)),)
  $(error Need PROFILE)
endif

ifeq ($(strip $(PROFILE_DIR)),)
  $(error Need PROFILE_DIR)
endif

include $(BUILD_ROOT)/deps/deps.mk

B := $(BUILD_DIR)

CFLAGS := -std=gnu11 -Wall -Wextra -Werror -pedantic

SRC := $(notdir $(wildcard $(PROFILE_DIR)/native/*.c))
$(info SRC: $(SRC))

OBJ := $(addprefix $(B)/$(PROFILE)/,$(SRC:%.c=%.o))
$(info OBJ: $(OBJ))

NATIVE_CC := gcc

.PHONY: default
default: $(B)/main.o $(OBJ)

$(B)/main.o: main.c server.h
	@echo Building $(@:$(BUILD_ROOT)/%=%)
	@$(NATIVE_CC) $(CFLAGS) -c $< -o $@  -g

$(OBJ): $(B)/$(PROFILE)/%.o: $(PROFILE_DIR)/native/%.c $(wildcard *.h)
	@echo Building $(@:$(BUILD_ROOT)/%=%)
	@mkdir -p $(dir $@)
	@$(NATIVE_CC) $(CFLAGS) -c $< -o $@ -I .

