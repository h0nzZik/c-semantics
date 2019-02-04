.PHONY: default
default: all

CDECL = cdecl-3-6
$(CDECL)/src/cdecl: $(srcdir)/deps/$(CDECL).tar.gz
	@echo "Building cdecl"
	tar -xvf $(srcdir)/deps/$(CDECL).tar.gz && cd $(CDECL) && ./configure --without-readline --disable-term-columns && $(MAKE)

cdecl: cdecl-3.6/src/cdecl
	cp $< .
	strip cdecl

# So in this Makefile we should only download the dependencies.
# And perl modules. The real Makefile will be in the `src/` directory.
cpanm:
	wget -O $@ 'http://cpanmin.us/'
	chmod +x $@

export PATH = $(CURDIR)/perl5/bin:$(PATH)
export PERL5LIB = $(CURDIR)/perl5/lib/perl5

CPANM = $(CURDIR)/cpanm --local-lib=$(CURDIR)/perl5

perl5: cpanm
	$(CPANM) --install local::lib SelfLoader Test

PERL_MODULES =
PERL_MODULES += Getopt::Declare
PERL_MODULES += String::Escape
PERL_MODULES += String::ShellQuote
PERL_MODULES += App::FatPacker
PERL_MODULES += UUID::Tiny

.PHONY: perl-modules
perl-modules: perl5
	$(CPANM) $(PERL_MODULES)

.PHONY: all
all: cdecl perl-modules
	cd src && $(MAKE)


# dependency: perl-devel
