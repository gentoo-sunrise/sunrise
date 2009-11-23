# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A FUSE filesystem for Linux with on-access file scanning through clamd daemon"
HOMEPAGE="http://clamfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/fuse
	dev-cpp/commoncpp2
	dev-libs/rlog
	dev-libs/poco"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-invalid_conversion.patch"
}
src_install() {
	emake install DESTDIR="${D}" || die "make install failed"
	dodoc AUTHORS ChangeLog README || die "dodoc failed"
	insinto /etc/${PN}
	newins doc/clamfs.xml clamfs.xml.example || die "newins failed"
}
