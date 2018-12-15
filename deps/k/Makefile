K_REPO := https://github.com/kframework/k.git
K_BRANCH := master
K_COMMIT := HEAD

ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
B := $(BUILD_DIR)

# We can use:
# * user provided K ($(USER_K_BIN))
# * cached K ($(CACHED_K_BIN))
# * custom build K $(OUR_K_BIN)

# OUR_K_BIN
# Our K

OUR_K_BIN := $(B)/k/k-distribution/target/release/k/bin

# USER_K_BIN
# User-provided K

ifneq (,$(strip $(K_BIN)))
  ifeq (,$(wildcard $(K_BIN)/kompile))
    $(info K_BIN: $(K_BIN))
    $(error K_BIN provided, but no 'kompile' detected)
  endif
  USER_K_BIN := $(K_BIN)
endif

# CACHED_K_BIN
# K from deps.mk

ifeq (,$(wildcard $(B)/deps.mk))
  CACHED_K_BIN :=
else
  include $(B)/deps.mk
  CACHED_K_BIN := $(K_BIN)
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


default: regenerate

$(B)/k:
	@echo 'Obtaining K from $(K_REPO)'
	@git clone --recursive --depth 1 --single-branch --branch $(K_BRANCH) $(K_REPO) $(B)/k
	@cd $(B)/k; git checkout $(K_COMMIT)

$(OUR_K_BIN): $(B)/k
	@echo 'Building K'
	@cd $(B)/k && mvn package -q -DskipTests -U

.PHONY: regenerate
regenerate: $(DESIRED_K_BIN)
	@#TODO should we test whether we really have it?
	@#$(DESIRED_K_BIN)/kompile --help
	@rm -f $(B)/deps.mk
	@echo 'K_BIN := $(DESIRED_K_BIN)' >> $(B)/deps.mk
	@cat deps.mk >> $(B)/deps.mk

#TODO ocaml backend
