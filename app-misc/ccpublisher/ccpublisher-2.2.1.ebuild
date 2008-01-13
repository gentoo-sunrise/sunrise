# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
WX_GTK_VER="2.6"
inherit zproduct python multilib wxwidgets

MY_PN="ccPublisher"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tool to tag and upload CC-licensed media files"
HOMEPAGE="http://wiki.creativecommons.org/CcPublisher"
SRC_URI="mirror://berlios/cctools/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="zope"

ZPROD_LIST="${MY_PN}"
S="${WORKDIR}/${MY_P}"

DEPEND=""
RDEPEND=">=dev-python/wxpython-2.6.3.2:2.6
	>=x11-libs/wxGTK-2.6.3.3:2.6
	zope? ( net-zope/zope )
	|| ( ( dev-python/elementtree >=dev-lang/python-2.4 ) >=dev-lang/python-2.5 )"

src_install() {
	# change directories, so that the python library is found
	sed -i "s#\.:#/usr/$(get_libdir)/${P}:# ; s#ccp.py#/usr/$(get_libdir)/${P}/ccp.py#" \
		ccPublisher.sh

	newbin ccPublisher.sh ccPublisher

	# docs
	dodoc README.txt resources/*txt

	# copy python libraries, no not include the script, readme or
	# zope libraries. zope libs will be installed if USE="zope"
	rm ccPublisher.sh README.txt -f
	mv "zope" "${WORKDIR}"
	insinto /usr/$(get_libdir)/${P}
	doins -r *

	# optimize python by compiling it
	python_mod_optimize /usr/$(get_libdir)/${P}

	# copy the zope Product folder
	if use zope; then

		einfo "Installing the Zope Product"

		# we need to reorganize a bit, since the zproduct
		# eclass defines S=$WORKDIR
		# the zope directory is already in $WORKDIR
		rm -rf "${S}/*"
		mv "${WORKDIR}/zope" "${S}/${MY_PN}"

		zproduct_src_install all

	fi
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${P}
}

pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}"usr/$(get_libdir)/${P}

	elog
	elog "ccPublisher is now installed to /usr/bin/ccPublisher"
	elog
	elog "If you get python errors, check that both wxpython and"
	elog "wxGTK are the same version."
	elog

	if use zope; then
		elog "The Zope Product has been installed."
		elog "Use \"zprod-manager add\" to activate it."
		elog
	fi
}
