srcdir = @srcdir@

.PHONY: default
default: all

#$(CDECL)/src/cdecl: $(srcdir)/deps/$(CDECL).tar.gz

CDECL = cdecl-3.6

cdecl-3.6/src/cdecl: $(srcdir)/deps/$(CDECL).tar.gz
	@echo "Building cdecl"
	tar -xvf $(srcdir)/deps/$(CDECL).tar.gz && cd $(CDECL) && ./configure --without-readline --disable-term-columns && $(MAKE)

cdecl: cdecl-3.6/src/cdecl
	cp $< .
	strip cdecl


CPANM = $(CURDIR)/cpanm --local-lib=$(CURDIR)/perl5

# So in this Makefile we should only download the dependencies.
# And perl modules. The real Makefile will be in the `src/` directory.
cpanm:
	wget -O $@ 'http://cpanmin.us/'
	chmod +x $@

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
	@echo ALL
	$(SHELL) build.sh
#cd src && env PATH=$(CURDIR)/../perl5/bin:$$PATH $(MAKE)


# dependency: perl-devel
