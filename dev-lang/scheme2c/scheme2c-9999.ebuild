# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EDARCS_REPOSITORY="http://darcs.debian.org/darcs/${PN}/${PN}/"

inherit eutils darcs multilib

DESCRIPTION="The Scheme->C compiler, R4RS compliant"
HOMEPAGE="http://alioth.debian.org/projects/scheme2c/"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="X doc"

DEPEND="dev-libs/libsigsegv
	   doc? ( virtual/ghostscript )
	   X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"

src_compile() {
	if use doc; then
		emake -C doc/ embedded.pdf index.pdf intro.pdf smithnotes.pdf || \
			die "Failed to build documents"
	fi

	if use x86; then
		emake forLINUX || die "Failed to set up Linux build"
		cd LINUX
	elif use amd64; then
		emake forAMD64 || die "Failed to set up AMD64 build"
		cd AMD64
	else
		die "Unimplemented architecture"
	fi

	# Due to insanity in the build system we have to touch these to
	# guarantee that everything will always get built
	touch scrt/*.c
	touch scsc/*.c

	emake -j1 all || die "Failed to compile"

	if use X; then
		emake -C cdecl || die "cdecl couldn't build"
		emake -C xlib -B sizeof.cdecl || die "cdecl couldn't run"
		emake -C xlib all || die "xlib bindings failed to build"
	fi
}

src_install() {
	if use x86; then
		cd LINUX
	elif use amd64; then
		cd AMD64
	else
		die "Unimplemented architecture"
	fi

	insinto /usr/$(get_libdir)/${PN}

# Only a small subset of files from scrt is required
	doins scrt/libsc.a scrt/predef.sc scrt/objects.h scrt/options.h ||  \
		die "Failed to install scrt files"

	dobin scrt/sci scsc/{scc,sccomp} || die "Failed to install binaries"

	if use X; then
		doins xlib/scxl.a || die "Failed to install X11 bindings"
		dobin xlib/scixl || die "Failed to install X11-aware interpreter"
		newdoc xlib/doc.txt xlib.txt || die "Failed to install X documentation"
	fi

	cd ..

	cp doc/scc.l doc/scc.1 || die
	cp doc/sci.l doc/sci.1 || die
	doman doc/{scc,sci}.1 || die "Failed to install man pages"

	if use doc; then
		dodoc doc/*.pdf || die "Failed to install pdf documentation"
	fi

	dodoc CHANGES README || die "Failed to install documentation"

	dosed -e "s:.*sccomp:sccomp:g" \
		-e"s:-LIBDIR.*t:-LIBDIR /usr/$(get_libdir)/scheme2c/ \
		-I/usr/$(get_libdir)/scheme2c/:g" \
		-e "s:-scmh 40:-scmh 1000 -sch 10:g" /usr/bin/scc || die
}
