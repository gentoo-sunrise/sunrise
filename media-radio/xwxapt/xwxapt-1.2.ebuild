# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="GTK+ linux weather satellite APT image decoder software"
HOMEPAGE="http://5b4az.chronos.org.uk/pages/apt.html"
SRC_URI="http://5b4az.chronos.org.uk/pkg/apt/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-libs/glib-2"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# create missing mkinstalldir and prepare package
	glib-gettextize --force --copy || die "gettextize failed"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dohtml doc/xwxapt.html || die "dohtml failed"
	insinto /usr/share/${PN}
	doins xwxapt/xwxaptrc || die "doins failed"
	dodir /usr/share/${PN}/images /usr/share/${PN}/records || die "dodir failed"
}

pkg_postinst() {
	einfo "You must copy the /usr/share/xwxapt directory into your home directory"
	einfo "and configure the contained xwxaptrc file before starting the program"
}
