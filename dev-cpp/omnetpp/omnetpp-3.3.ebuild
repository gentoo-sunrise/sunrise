# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="A C++-based object-oriented discrete event simulation."
HOMEPAGE="http://www.omnetpp.org/"
SRC_URI="http://www.omnetpp.org/download/release/${P}-src.tgz"

LICENSE="omnetpp"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

RDEPEND="=dev-lang/tcl-8.4*
	=dev-lang/tk-8.4*
	dev-lang/perl
	dev-libs/libxslt
	virtual/ghostscript
	media-gfx/imagemagick
	media-gfx/graphviz"
DEPEND="${RDEPEND}
	app-doc/doxygen
	sys-devel/bison"

src_compile() {
	export PATH="${PATH}:${S}/bin"
	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${S}/lib"
	export TCL_LIBRARY="/usr/$(get_libdir)/tcl8.4"
	econf || die 'econf failed'
	emake || die 'emake failed'
}

src_install() {
	rm -f bin/neddoc*
	dolib lib/*
	dobin bin/*
	dodoc doc/*
	insinto "/usr/share/doc/${PF}/bitmaps"
	doins -r bitmaps/* || die "installing bitmaps failed"
	if use examples ; then
		insinto "/usr/share/doc/${PF}/samples"
		doins -r samples/* || die "installing samples failed"
		for x in $(find ./samples -executable -type f); do
			exeinto "/usr/share/doc/${PF}/$(dirname ${x})"
			doexe "${x}"
		done;
	fi
}

pkg_postinst() {
	if use examples ; then
		elog "In order to provide the samples"
		elog "please copy them to a user home directory."
		elog "The samples are located in:"
		elog "   /usr/share/doc/${PF}/samples"
	fi
}
