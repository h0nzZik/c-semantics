# Autoconf requirements

# AC_INIT
AC_INIT([c-semantics], [1.0])

# Information on the package

# Check for programs
AC_PROG_LEX

# Checks for libraries

# Checks for C header files, types and structures

# Checks for C compiler characteristics
 # na co po potrebujeme? Na knihovnu, parsery, testy...

# Ok, testy testuji co? Jsou to testy pro semantiku + parser + knihovnu...
# Jsou to teda nejake testy pro balik? A baliky se kombinuji z jinych baliku?

# Ok, ale semantika a knihovna je uz jiny softwarovy package. Ne?
# Jak se softwarove balicky kombinuji?
# Flatpak?

# Flatpak.
# - Root
#   - rv-kcc
#   - profiles/A,B,C
#   - c-parser
#   - cpp-parser
#
# - A profile:
#   - semantics
#   - library
#
#
#
# /usr/lib/rv-match/
#
#
# TODO co s testy?
#
#
# Hadam, ze tedy bude jeden configure.am pro kazdou komponentu:
# - c-parser
# - cpp-parser
# - rv-kcc
#
# Ale co profily? Muzeme mit jeden configure.am pro sestaveni profilu?
# Parametry: cesta k c-parser, cpp-parser, rv-kcc.
# Asi je rozdil mezi instalacni cestou a soucasnou cestou.
# Dalsi parametry: nazev profilu, cesta ke zdrojakum profilu.
# Takze potrebuji adresar popisujici profil.
#
#
# Co je profil? Sklada se ze:
# - K zdrojaku
# - Zdojaku knihovny, pripadne patchu pro knihovnu.
#
#
# Mozna ze jeden package je standardni knihovna: zavisi na sestavene semantice,
# zdrojacich, ...File
#


# File system hierarchy standard
#
#
# So the difference is in the profiles...
# I would need one branch in c-semantics for this,
# and one branch in rv-match repository.
# We will make sure they work together
# and then switch them for master branches.
# Talk with Dwight about this.

