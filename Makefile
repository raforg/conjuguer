# The next group of variables must be edited to suit your needs.
# They control where conjuguer is installed.
BINDIR := /usr/local/bin
DATADIR := /usr/local/share/conjuguer
#WEBDIR := /var/vwebsites/raf.org/conjuguer
#CGIDIR := /var/vwebsites/raf.org/cgi-bin
WEBDIR := /var/www/html/conjuguer
CGIDIR := /var/www/cgi-bin
#WEBDIR := /home/raf/Sites/conjuguer
#CGIDIR := /Library/WebServer/CGI-Executables

# This group of variables should not be changed.
SRCFILES := README Makefile conjuguer conjugaisons verbes usage.doco doco2html audit hist revchk revchk2 urlchk
IDXFILES := conjugaisons.idx verbes.idx reverse.idx
CGIFILES := conjuguer conjugaisons verbes $(IDXFILES)
TARFILE := conjuguer.tar.gz

#SHELL := zsh # Zsh's time command has nicer output than bash's

output:
	@[ -f output ] && mv output output.prev; \
	time ./conjuguer > output; \
	[ $$? = 0 ] || mv output.prev output; \
	[ -f output.prev ] && diff -u output.prev output > output.diff; \
	ls -l output*; \
	time ./audit output > audit.out; \
	./hist -t audit.out

$(IDXFILES): verbes conjugaisons
	time ./conjuguer manger >/dev/null
	time ./conjuguer -R

cgi: $(IDXFILES)
	cp -p $(CGIFILES) $(CGIDIR)

web: cgi dist
	time ./conjuguer -W -D $(WEBDIR)
	cp -p ../$(TARFILE) $(WEBDIR)

index: cgi
	time ./conjuguer -W -D $(WEBDIR) -I

install: $(IDXFILES)
	[ -d $(BINDIR) ] || mkdir $(BINDIR)
	[ -d $(DATADIR) ] || mkdir $(DATADIR)
	cp -p $(CGIFILES) $(DATADIR)
	(echo "#!/bin/sh"; echo "exec $(DATADIR)/conjuguer \"\$$@\"") > $(BINDIR)/conjuguer

uninstall:
	rm -r $(DATADIR) $(BINDIR)/conjuguer

dist:
	@set -e; \
	dir="`basename \`pwd\``"; \
	cd ..; \
	tar czf $(TARFILE) $(patsubst %, $$dir/%, $(SRCFILES)); \
	tar tzf $(TARFILE) | sort

clean:
	rm -f $(TARFILE) audit.out

clobber: clean
	rm -f $(IDXFILES) output* revchk.out revchk2.out urlchk.out usage.html .htaccess

help:
	@echo "This makefile supports the following targets:"; \
	echo "  output    - generate all conjugations in a single text file (default)"; \
	echo "  cgi       - copy cgi-related files to $(CGIDIR)"; \
	echo "  web       - cgi + generate website files into $(WEBDIR)"; \
	echo "  index     - generate web index pages only to $(WEBDIR)"; \
	echo "  install   - install to $(BINDIR) and $(DATADIR)"; \
	echo "  uninstall - uninstall from $(BINDIR) and $(DATADIR)"; \
	echo "  dist      - tar up the source for distribution"; \
	echo "  clean     - delete the tarfile and audit.out"; \
	echo "  clobber   - clean + delete index and output files"; \

