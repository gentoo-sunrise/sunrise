# Copyright 2006-2006 Mikael Lammentausta
# Distributed under the terms of the GNU General Public License v2

inherit eutils zproduct

MY_P="ccPublisher-${PV}"

DESCRIPTION="Tool to tag and upload CC-licensed media files"
HOMEPAGE="http://wiki.creativecommons.org/CcPublisher"
SRC_URI="http://download.berlios.de/cctools/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="zope"

ZPROD_LIST="ccPublisher"

DEPEND=">=dev-python/wxpython-2.6.3.2
	>=x11-libs/wxGTK-2.6.3.3
	zope? ( net-zope/zope )
	|| ( dev-python/elementtree >=dev-lang/python-2.5 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	# change directories, so that the python library is found
	sed -i -e "s#\.:#/usr/lib/${P}:# ; s#ccp.py#/usr/lib/${P}/ccp.py#" ccPublisher.sh

	dobin ccPublisher.sh ccPublisher

	# docs
	dodoc README.txt
	dodoc resources/*txt

	rm -f ccPublisher* README.txt

	# copy python libraries
	dodir /usr/lib/${P}
	insinto /usr/lib/${P}
	doins -r ${S}/*

	# copying the zope Product folder
	if use zope; then
		einfo "Installing the Zope Product"
		zproduct_src_install all
	fi
}

pkg_postinst() {
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
