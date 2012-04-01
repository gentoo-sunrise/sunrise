# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"

inherit eutils multilib python

DESCRIPTION="A graphical newsreader written in Python"
HOMEPAGE="http://xpn.altervista.org/index-en.html"
SRC_URI="
	mirror://debian/pool/main/x/${PN}/${PN}_${PV}-5.debian.tar.gz
	http://xpn.altervista.org/codice/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

LANGS="de fr it"
for i in ${LANGS} ; do
	IUSE="${IUSE} linguas_${i}"
done

DEPEND=""
RDEPEND="
	dev-python/pygtk
	x11-libs/gtk+:2"

pkg_setup() {
	python_set_active_version 2
	python_convert_shebangs -r 2 .
}

src_prepare() {
	# Debian Patches
	epatch "${WORKDIR}"/debian/patches/0{1..4}*.patch
}

src_install() {
	for i in ${LANGS} ; do
		insinto /usr/share/locale
		use linguas_${i} && doins -r lang/${i}
	done

	insinto $(python_get_sitedir)/${PN}/
	doins -r pixmaps xpn_src ${PN}.py

	newicon pixmaps/xpn-icon.png ${PN}.png
	make_desktop_entry "${PN} -d" ${PN} /usr/share/pixmaps/${PN}.png "Network;News"

	dodoc AUTHORS ChangeLog README
	dohtml xpn.html

	make_wrapper ${PN} "python2 ${PN}.py" $(python_get_sitedir)/${PN}

	python_need_rebuild
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
