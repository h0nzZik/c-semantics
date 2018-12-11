K_REPO := https://github.com/kframework/k.git

ifeq ($(strip $(BUILD_DIR)),)
  $(error Need BUILD_DIR)
endif
$(info BUILD_DIR: $(BUILD_DIR))
B := $(BUILD_DIR)


CUSTOM_K_BIN := $(B)/k/k-distribution/target/release/k/bin

ifeq ($(strip $(K_BIN)),)
  K_BIN := $(CUSTOM_K_BIN)
  WORK_TO_DO := $(CUSTOM_K_BIN)
else
  WORK_TO_DO := trivial-k
endif

.PHONY:
default: $(B)/deps.mk $(WORK_TO_DO)

.PHONY: trivial-k
trivial-k:
	@echo 'K found in K_BIN: $(K_BIN)'

$(B)/k:
	@echo 'Obtaining K from $(K_REPO)'
	@git clone --recursive $(K_REPO) $(B)/k

$(CUSTOM_K_BIN): $(B)/k
	@echo 'Building K'
	@cd $(B)/k && mvn package -q -DskipTests -U

$(B)/deps.mk: $(WORK_TO_DO)
	$(eval K_BIN_REAL := $(realpath $(K_BIN)))
	@#TODO should we test if we really have it?
	@#$(K_BIN_REAL)/kompile --help
	@rm $@
	@echo 'K_BIN := $(K_BIN_REAL)' >> $@
	@echo 'KOMPILE := $$(K_BIN)/kompile' >> $@
	@echo 'KRUN := $$(K_BIN)/krun' >> $@
	@echo 'KDEP := $$(K_BIN)/kdep' >> $@

#TODO ocaml backend
