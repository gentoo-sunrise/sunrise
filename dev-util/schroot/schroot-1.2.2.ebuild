# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
inherit eutils autotools

DESCRIPTION="A secure chroot implementation using PAM"
HOMEPAGE="http://packages.debian.org/source/sid/schroot"

SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls static test"

RDEPEND=">=dev-libs/boost-1.34.0
	>=dev-libs/lockdev-1.0.2
	sys-libs/pam"

DEPEND="${RDEPEND}
	test? ( >=dev-util/cppunit-1.10.0 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}.{pamfix,autotools,test}.patch"
	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf $(use_enable debug) \
		$(use_enable nls) \
		$(use_enable static) \
		$(use_enable test)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO || die
}
