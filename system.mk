ifneq (,$(wildcard /etc/fedora-release))
  include Fedora.mk
else
ifeq (,$(wildcard /etc/os-release))
 include Debian.mk
else
  $(error Unknown operating system)
endif
