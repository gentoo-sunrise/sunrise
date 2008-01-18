# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Intelligent Wardialer Program"
HOMEPAGE="http://www.softwink.com/iwar"
SRC_URI="http://softwink.com/iwar/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="iax2 mysql"

DEPEND="sys-libs/ncurses
	mysql? ( dev-db/mysql )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	EPATCH_SOURCE="${FILESDIR}"
	EPATCH_SUFFIX="patch"
	EPATCH_FORCE="yes" epatch
}

src_compile() {
	econf $(use_enable mysql) \
		$(use_enable iax2)

	emake || die "emake failed"
}

src_install() {
	dodir /etc/iwar
		emake DESTDIR="${D}" install || die "Install failed"
		dodoc AUTHORS ChangeLog FAQ MODEMS-TESTED README README.IAX2 THANKS TODO
		doman "${FILESDIR}"/${PN}.1
}

pkg_postinst() {
	elog "Users must be in group uucp in order to be able to use iwar."
}
