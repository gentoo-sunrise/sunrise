# Copyright 2006-2006 Mikael Lammentausta
# Distributed under the terms of the GNU General Public License v2

inherit eutils zproduct

DESCRIPTION="Tool to tag and upload CC-licensed media files"
HOMEPAGE="http://wiki.creativecommons.org/CcPublisher"
SRC_URI="http://download.berlios.de/cctools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="zope"

ZPROD_LIST="ccPublisher"
S="${WORKDIR}/${P}"

DEPEND=">=dev-lang/python-2.4
        >=dev-python/wxpython-2.6.3.2
		>=x11-libs/wxGTK-2.6.3.3
		sys-apps/sed
		zope? (net-zope/zope)
		dev-python/elementtree" #elementtree is not required for
		                        # python 2.5 or later

RDEPEND="${DEPEND}"

src_install() {
	cd ${S}

	# change directories, so that the python library is found
	sed "s#\.:#/usr/lib/${P}:# ; s#ccp.py#/usr/lib/${P}/ccp.py#" \
		ccPublisher.sh > ccPublisher

	dobin ccPublisher

	# docs
	dodoc README.txt
	dodoc resources/*txt

	# copy python libraries
	dodir /usr/lib/${P}
	#insinto /usr/lib/${P}
	#doins does not copy recursively
	rm ccPublisher* README.txt -f
	cp ${S}/* -r ${D}/usr/lib/${P}

	# copying the zope Product folder
	if use zope; then

		einfo "Installing the Zope Product"

		# we need to reorganize a bit, since the zproduct
		# eclass defines S=$WORKDIR
		cd ${WORKDIR}
		mv ${S}/zope ${WORKDIR}
		rm -fr ${S}/*
		mv ${WORKDIR}/zope ${S}/${PN}

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

