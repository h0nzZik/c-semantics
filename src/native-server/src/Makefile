include ../inc.mk

ifeq ($(strip $(PROFILE)),)
  $(error Need PROFILE)
endif

ifeq ($(strip $(PROFILE_DIR)),)
  $(error Need PROFILE_DIR)
endif

CFLAGS := -std=gnu11 -Wall -Wextra -Werror -pedantic

SRC := $(notdir $(wildcard $(PROFILE_DIR)/native/*.c))
$(info SRC: $(SRC))

OBJ := $(addprefix $(B)/$(PROFILE)/,$(SRC:%.c=%.o))
$(info OBJ: $(OBJ))

NATIVE_CC := gcc

.PHONY: default
default: $(B)/main.o $(OBJ)

$(B)/main.o: main.c server.h
	@$(GENERATING)
	@$(NATIVE_CC) $(CFLAGS) -c $< -o $@  -g

$(OBJ): $(B)/$(PROFILE)/%.o: $(PROFILE_DIR)/native/%.c $(wildcard *.h)
	@$(GENERATING)
	@mkdir -p $(dir $@)
	@$(NATIVE_CC) $(CFLAGS) -c $< -o $@ -I .

