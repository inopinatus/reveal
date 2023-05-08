.PHONY: all clean install

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man/man1
SWIFTC ?= swiftc
INSTALL ?= install

all: reveal

reveal: reveal.swift
	$(SWIFTC) -v -O -o $@ $<

install: reveal
	$(INSTALL) -v -C -m 755 $< $(BINDIR)/$<
	$(INSTALL) -v -C -m 644 reveal.1 $(MANDIR)/reveal.1

uninstall:
	rm -f $(BINDIR)/reveal
	rm -f $(MANDIR)/reveal.1

clean:
	rm -f reveal
