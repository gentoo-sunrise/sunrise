# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils

DESCRIPTION="A notification applet for Gmail that's alternative to the one released from Google"
HOMEPAGE="http://gmail-notify.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/gnome-python-extras
	>=dev-python/pygtk-2.0"

S=${WORKDIR}/${PN}

src_unpack() {
	python_version
	unpack ${A}
	cd "${S}"
	epatch	"${FILESDIR}/${PN}-conf-perms.patch" \
		"${FILESDIR}/${PN}-trayicon.patch" \
		"${FILESDIR}/${PN}-ubuntu-patches.patch"

	# substitute the "GENTOO_PYVER" that was added by ${PN}-ubuntu-patches.patch
	sed -i -e "s/GENTOO_PYVER/${PYVER}/g" *.py || die "Sed broke!"
}

src_install() {
	python_version
	local instdir=$(python_get_sitedir)/${PN}

	dodoc README || die

	insinto "${instdir}"
	doins *.py *.jpg *.png langs.xml notifier.conf.sample || die

	make_wrapper gmail-notify "${python} ${instdir}/notifier.py"
}

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)/${PN}"
	einfo
	einfo "Run gmail-notify to start the program"
	einfo
	ewarn "Warning: if you check the 'save username and password' option"
	ewarn "your password will be stored in plaintext in ~/.notifier.conf"
}

pkg_postrm() {
	python_mod_cleanup "$(python_get_sitedir)/${PN}"
}
