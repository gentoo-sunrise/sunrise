# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOMAKE="1.9"
inherit eutils autotools

DESCRIPTION="mockpp is a platform independent generic unit testing framework for C++."
HOMEPAGE="http://mockpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="boost cppunit doc"

RDEPEND="cppunit? ( dev-util/cppunit )
	boost? ( dev-libs/boost )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen
		app-text/docbook-xml-dtd
		dev-java/fop )"

pkg_setup() {
	if use boost && use cppunit; then
		ewarn
		ewarn "Both boost and cppunit use-flags specified, will use boost"
		ewarn
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PV}-destdir.patch"
	epatch "${FILESDIR}/${PV}-boost_incdir_m4.patch"
	eautoreconf
}

src_compile() {
	econf \
		$(use_enable cppunit) \
		$(use_enable boost boosttest) \
		$(use_enable doc doxygen) \
		$(use_enable doc docbook) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	# docs get build & installed only if doc use-flag is specified
	emake DESTDIR="${D}" DOCDIR="/usr/share/doc/${PF}" install || die "emake install failed"
	dodoc ChangeLog AUTHORS README TODO
}
