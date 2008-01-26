# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils versionator

MY_PV="$(delete_all_version_separators)"
DESCRIPTION="CyberLink for C++ is a development package for UPnP programmers."
HOMEPAGE="https://sourceforge.net/projects/clinkcc/"
SRC_URI="mirror://sourceforge/${PN}/clinkcc${MY_PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="expat xml mythtv"

DEPEND="expat? ( >=dev-libs/expat-1.95 )
	xml? ( >=dev-libs/libxml2-2.6.20 )
	!expat? ( !xml? ( >=dev-libs/xerces-c-2.3 ) )
	mythtv? ( virtual/mysql )
	virtual/libiconv"
RDEPEND="${DEPEND}"

S=${WORKDIR}/CyberLink/

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/gcc-4.1.patch"
	eautoreconf
}

src_compile() {
	econf $(use_enable expat) \
		$(use_enable xml libxml2) \
		$(use_enable mythtv)

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
