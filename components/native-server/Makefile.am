ACLOCAL_AMFLAGS = -I m4

lib_LTLIBRARIES = libserver.la
libserver_la_SOURCES = main.c server.h platform.h

#TODO the server may dlopen individual platform-specific plugins.

#include ../inc.mk
#
#ifeq ($(strip $(PROFILE_DIR)),)
#  $(error Need PROFILE_DIR)
#endif
#
#CFLAGS := -std=gnu11 -Wall -Wextra -Werror -pedantic
#
#SRC := $(notdir $(wildcard $(PROFILE_DIR)/native/*.c))
#OBJ := $(addprefix $(B)/,$(SRC:%.c=%.o))
#
#NATIVE_CC := gcc
#
#.PHONY: default
#default: $(B)/main.o $(OBJ)
#
#$(B)/main.o: main.c server.h
#	@$(GENERATING)
#	@$(NATIVE_CC) $(CFLAGS) -c $< -o $@  -g
#
#$(OBJ): $(B)/%.o: $(PROFILE_DIR)/native/%.c $(wildcard *.h)
#	@$(GENERATING)
#	@mkdir -p $(dir $@)
#	@$(NATIVE_CC) $(CFLAGS) -c $< -o $@ -I .

