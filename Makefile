# Makefile for cygwin-bass
# cxw/Incline 2018
# CC-BY 4.0 International
#
# Invoke as `make DLL=<path to bass.dll>`

# Thanks to https://cygwin.com/cygwin-ug-net/dll.html and
# DEF syntax in the comments of
# https://github.com/CyberGrandChallenge/binutils/blob/master/binutils/dlltool.c

T=bass
TGT=lib$(T).a
DLL ?= $(T).dll

$(TGT): $(T).def
	dlltool --def $(T).def --dllname $(T).dll --output-lib $(TGT)

$(T).def: $(DLL) Makefile
	-rm -f $@
	echo "LIBRARY $(T)" > $@
	echo EXPORTS >> $@
	objdump -xt $(DLL) | perl -ne 'print "\t$$2 @ $$1\n" if /\[\s*([0-9]+)\]\s*(BASS_.*)$$/' >> $@
	#nm $(T).dll | grep ' T _' | sed 's/.* T _//' >> $(T).def

.PHONY: clean
clean:
	rm $(TGT) $(T).def

