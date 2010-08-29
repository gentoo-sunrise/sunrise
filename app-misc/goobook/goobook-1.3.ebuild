# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
inherit distutils

DESCRIPTION="Google Contacts wrapper for mutt"
HOMEPAGE="http://code.google.com/p/goobook/"
SRC_URI="mirror://pypi/g/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/gdata
	dev-python/argparse
	=dev-python/hcs-utils-1.1.1
	dev-python/simplejson"

RESTRICT_PYTHON_ABIS="3.*"

pkg_postinst() {
	distutils_pkg_postinst

	einfo	"If you want to use goobook from mutt"
	einfo	"set in your .muttrc file:"
	einfo
	einfo	"set query_command=\"goobook query '%s'\""
	einfo
	einfo	"to query address book. (Normally bound to \"Q\" key.)"
	einfo	
	einfo	"You can customize few other settings. Please take a look"
	einfo	"at http://pypi.python.org/pypi/${PN}/${PV} in \"Configure/Mutt\" section"
	einfo
	ewarn	"If you are upgrading from v1.2 then you may encounter few issues."
	ewarn	"In order to fix that, you have to delete your old cache:"
	ewarn	"rm ~/.goobook_cache"
}
