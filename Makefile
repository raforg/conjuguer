# conjuguer - french verb conjugation website
# https://raf.org/conjuguer
# https://github.com/raforg/conjuguer
# https://codeberg.org/raforg/conjuguer
#
# Copyright (C) 2003-2007, 2023 raf <raf@raf.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <https://www.gnu.org/licenses/>.
#
# 20230408 raf <raf@raf.org>

# The next group of variables must be edited to suit your needs.
# They control where conjuguer is installed.
BINDIR := /usr/local/bin
DATADIR := /usr/local/share/conjuguer

WEBDIR := /var/www/html/conjuguer
CGIDIR := /var/www/cgi-bin
#WEBDIR := /var/vwebsites/raf.org/conjuguer
#CGIDIR := /var/vwebsites/raf.org/cgi-bin

# This group of variables should not be changed.
ADMFILES := README.md CHANGELOG CODE_OF_CONDUCT.md COPYING LICENSE LICENSES .reuse
SRCFILES := $(ADMFILES) Makefile conjuguer conjugaisons verbes usage.doco doco2html audit hist revchk revchk2 urlchk
IDXFILES := conjugaisons.idx verbes.idx reverse.idx
CGIFILES := conjuguer conjugaisons verbes $(IDXFILES)
TARFILE := conjuguer.tar.gz

output:
	@[ -f output ] && mv output output.prev; \
	./conjuguer > output; \
	[ $$? != 0 -a -f output.prev ] && mv output.prev output; \
	[ -f output.prev ] && diff -u output.prev output > output.diff; \
	ls -l output*; \
	./audit output > audit.out; \
	./hist -t audit.out

$(IDXFILES): verbes conjugaisons
	./conjuguer manger >/dev/null
	./conjuguer -R

cgi: $(IDXFILES)
	cp -p $(CGIFILES) $(CGIDIR)

web: cgi dist
	./conjuguer -W -D $(WEBDIR)
	cp -p ../$(TARFILE) $(WEBDIR)

index: cgi
	./conjuguer -W -D $(WEBDIR) -I

install: $(IDXFILES)
	[ -d $(BINDIR) ] || mkdir -p $(BINDIR)
	[ -d $(DATADIR) ] || mkdir -p $(DATADIR)
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
	rm -f $(TARFILE) audit.out revchk.out revchk2.out urlchk.out

clobber: clean
	rm -f $(IDXFILES) output* usage.html .htaccess

help:
	@echo "This makefile supports the following targets:"; \
	echo "  output    - generate all conjugations in a single text file (default)"; \
	echo "  cgi       - copy cgi-related files to $(CGIDIR)"; \
	echo "  web       - cgi + generate website files into $(WEBDIR)"; \
	echo "  index     - generate web index pages only to $(WEBDIR)"; \
	echo "  install   - install to $(BINDIR) and $(DATADIR)"; \
	echo "  uninstall - uninstall from $(BINDIR) and $(DATADIR)"; \
	echo "  dist      - create a tarfile of the source for distribution"; \
	echo "  clean     - delete the tarfile and *.out"; \
	echo "  clobber   - clean + delete index and output files"; \
	echo "  help      - Show this message"; \
	echo; \
	echo "See also revchk, revchk2, and urlchk"

