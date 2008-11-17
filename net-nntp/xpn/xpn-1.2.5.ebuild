# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python eutils multilib

DESCRIPTION="A graphical newsreader written in Python"
HOMEPAGE="http://xpn.altervista.org/index-en.html"
SRC_URI="http://xpn.altervista.org/codice/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

LANGS="de fr it"
for i in ${LANGS} ; do
	IUSE="${IUSE} linguas_${i}"
done

DEPEND=""
RDEPEND=">=dev-lang/python-2.5
	>=dev-python/pygtk-2.10
	>=x11-libs/gtk+-2.10"

src_install() {
	python_version
	exeinto /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
	doexe ${PN}.py

	for i in ${LANGS} ; do
		insinto /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}/lang
		use linguas_${i} && doins -r lang/${i}
	done

	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}/pixmaps
	doins pixmaps/*

	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}/xpn_src
	doins xpn_src/*

	newicon pixmaps/xpn-icon.png ${PN}.png
	make_desktop_entry "${PN} -d" ${PN} ${PN}.png "Network;News"

	dodoc AUTHORS ChangeLog README
	dohtml xpn.html

	make_wrapper ${PN} ./${PN}.py /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}

	python_need_rebuild
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
}

pkg_postrm() {
	python_mod_cleanup
}
