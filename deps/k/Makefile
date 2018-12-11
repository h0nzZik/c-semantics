K_REPO := https://github.com/kframework/k.git

ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
$(info BUILD_DIR: $(BUILD_DIR))
B := $(BUILD_DIR)

# We can use:
# * user provided K ($(USER_K_BIN))
# * cached K ($(CACHED_K_BIN))
# * custom build K $(OUR_K_BIN)

USER_K_BIN := $(K_BIN)
K_BIN :=
ifneq (,$(strip $(USER_K_BIN)))
  ifeq (,$(wildcard $(USER_K_BIN)/kompile))
    $(info USER_K_BIN: $(USER_K_BIN))
    $(error USER_K_BIN provided, but no 'kompile' detected)
  endif
endif

OUR_K_BIN := $(B)/k/k-distribution/target/release/k/bin
ifeq (,$(wildcard $(B)/deps.mk))
  CACHED_K_BIN :=
else
  $(info reading cache)
  -include $(B)/deps.mk
  CACHED_K_BIN := $(K_BIN)
  K_BIN :=
endif

#TODO use lists
ifneq (,$(strip $(USER_K_BIN)))
  DESIRED_K_BIN := $(USER_K_BIN)
else
  ifneq (,$(strip $(CACHED_K_BIN)))
    DESIRED_K_BIN := $(CACHED_K_BIN)
  else
    DESIRED_K_BIN := $(OUR_K_BIN)
  endif
endif

$(info USER_K_BIN: $(USER_K_BIN))
$(info DESIRED_K_BIN: $(DESIRED_K_BIN))

default: regenerate

$(B)/k:
	@echo 'Obtaining K from $(K_REPO)'
	@git clone --recursive $(K_REPO) $(B)/k

$(OUR_K_BIN): $(B)/k
	@echo 'Building K'
	@cd $(B)/k && mvn package -q -DskipTests -U

.PHONY: regenerate
regenerate: $(DESIRED_K_BIN)
	@#$(eval K_BIN_REAL := $(realpath $(DESIRED_K_BIN)))
	@#TODO should we test if we really have it?
	@#$(K_BIN_REAL)/kompile --help
	@rm -f $(B)/deps.mk
	@echo 'K_BIN := $(K_BIN_REAL)' >> $(B)/deps.mk
	@echo 'KOMPILE := $$(K_BIN)/kompile' >> $(B)/deps.mk
	@echo 'KRUN := $$(K_BIN)/krun' >> $(B)/deps.mk
	@echo 'KDEP := $$(K_BIN)/kdep' >> $(B)/deps.mk

#TODO ocaml backend
