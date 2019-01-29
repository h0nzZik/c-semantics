Every component has to specifify its build-time dependencies - tools that have to be present on the system when the build is run. Those typically are: wget, git, make, cmake, maven, autoconf, maven. In `BUILD.md`. This file should also describe how to build the component. The description does not need to be detailed - if the component uses autoconf, one should be able to simply run `./configure --help`.

The required tools are then 



Cely RV-Match zavisi na jednom baliku/modulu pro K. Tento zase zavisi/obsahuje konkretni ocaml, konkretni llvm apod. Pri buildu RV-Match nemohu nutit uzivatele, aby si K stahl a nainstaloval. To musim udelat ja. Casem bych mu ale mel poskytnout tu moznost pouzit vlastni... . Existuje nejaky system pro stahovani a rozbalovani veci? Ano, potrebuji wget, unzip apod.

Ale libi se mi GIMPovsky pristup s `autogen.sh` nebo lepe `./bootstrap.sh`.
Ubuntu: package `autotools-dev`

Budu potrebovat toplevel `configure` script?

Mohu mit nejaky Makefile, ktery se postara o stahovani a buildeni zavislosti.
Napriklad mohu mit target:
```
$(BUILD_DIR)/deps/k/pom.xml:
	mkdir -p $(dir $@)
	git clone ... $(K_REPO) $(K_VERSION)
```
pro stazeni K. S tim, ze nejaky toplevel ./configure script bude brat prepinace,
ktere umozni nastavit, ze se misto tohoto adresare budeme koukat na 

Tohle je ale zavislost pro cely RV-Match, resp. pro celou semantiku. Dava tedy smysl, abychom meli toplevel configure && make. Nevim ale, jak maji fungovat jednotlive podprojekty. To, jakou verzi clangu pouziva cpp-parser, do toho hornim vrstvam projektu nic neni. I kdyz. Asi bychom nemeli mit makro `CONFIG_DEP_CLANG_VERSION`, protoze to by implikovalo globalni zavislost. Ale muzeme mit makro `CONFIG_CPPPARSER_CLANG_VERSION. Otazka: chceme byt schopni buildovat jednotlive komponenty samostatne? Me to prijde jako dobry napad pro testovani. Zaroven ta komponenta sama (cpp-parser) vi, kde najit tu zavislost (odkud ji stahnout). A jestli pouzit wget, curl, nebo git.

Toplevel `./configure` staci volat jen jednou. Tahle vec ale nebude sama stahovat zadne veci. Mozna bychom mohli mit target `get-dependencies` a `build-dependencies`.

Toplevel `./configure` bude volat `./clang-tools/configure` i `./cparser/configure`, i `./kcc/configure`. Preda jim uzitecne informace. Treba pokud chce uzivatel pouzivat K ziskane odjinud, muze to specifikovat tomu toplevel `configure` skriptu a ten to preda tomu pro `kcc`.

Ale toplevel `./configure` vygeneruje `Makefile`, a musi byt mozna volat `make`. Nechci rekurzivni `make`, to zbytecne prekazi a brani paralelismu. V tom musi byt nejake default targety (`default`, `build`, `clean` apod). Ale protoze nechci rekurzivni Make, musim includovat podprojektove Makefiles (po `kcc`, `cparser` apod). V tech ale nesmi byt defaultni targety. Ale take chci byt schopen buildit podprojekty samostatne. Tozn. v `kcc` se bude nachazet `inc.mk` a `Makefile`, pricemz toplevel `Makefile` (generovany z `Makefile.am`) bude includovat `kcc/inc.mk`. Komponentovy `kcc/Makefile` bude take includovat `inc.mk`. Jeste nevim, zda budou tyto generovane pres Autoconf nebo rucne psane. Uvidime dle potreby. Ale asi by mely byt generovane pres autoconf, nebo alespon ten `inc.mk` - protoze bude obsahovat cesty k zavislostem (treba K). Takze abych to sjednotil, mozna bych mohl mit i v toplevel i v ostatnich modulech nasledujici soubory:
- `configure.ac` --> `configure`
- `inc.mk.ac` --> `inc.mk`
- `Makefile`

A dokonce ten Makefile by mozna mohl byt jeden, stejny vsude. Nebo ne? Ne. On totiz bude obsahovat vazbu na konkretni targety v `inc.mk`. Je to takovy wrapper.

Ne. Ja zde nepotrebuji zadne `inc.mk`. Muzu pouzit normalni rekurzivni make.

Ty `configure` skripty si samozrejme budou predavat i instalacni adresare apod.

TODO try to `./configure && make` GIMP.


All dependencies:
* ocaml
