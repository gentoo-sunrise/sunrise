# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"

inherit autotools eutils

DESCRIPTION="A suite of standard drivers, a PPD file compiler, and other utilities to develop printer drivers for CUPS and other printing environments."
HOMEPAGE="http://www.cups.org/ddk/index.php"
SRC_URI="http://dev.gentooexperimental.org/~jdettner/gentoo/cupsddk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="fltk"

DEPEND=">=net-print/cups-1.2
	fltk? ( =x11-libs/fltk-1.1* )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix prestripped binaries, nuke SVN dirs
	sed -i -e "/INSTALL_BIN/s/-s//" Makedefs.in || die "sed failed"
	find . -type d -name '.svn' -print0 | xargs -0 rm -rf

	# fix automagic fltk dependency
	epatch "${FILESDIR}"/${PN}-fltk-automagic.patch
	eautoconf
}

src_compile() {
	econf BUILDROOT="${D}" \
		--with-docdir=/usr/share/doc/${PF} \
		$(use_with fltk) \
		|| die "econf failed"
	emake BUILDROOT="${D}" || die "emake failed"
}

src_install() {
	emake BUILDROOT="${D}" install || die "emake install failed"
	keepdir /usr/share/cups/drv

	# FIXME!!! This thing would collide with a directory installed by cups
	# no idea why is it installed there
	mv ${D}/usr/libexec/cups/driver ${D}/usr/bin/cupsddk-driver

	rm -f LICENSE.* doc/Makefile
	dodoc *.txt
	dohtml -r doc/*
}

pkg_postinst() {
	elog "*** FIXME!!! ***"
	elog "The included driver binary has been installed as /usr/bin/cupsddk-driver"
	elog "to prevent collision with a directory installed by cups"
	elog "*** FIXME!!! ***"
}
