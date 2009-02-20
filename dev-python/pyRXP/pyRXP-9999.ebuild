# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils subversion

DESCRIPTION="Binding to RXP, a very fast validating XML parser."
HOMEPAGE="http://www.reportlab.org/pyrxp.html"
ESVN_REPO_URI="http://svn.reportlab.com/svn/public/${PN}/trunk/src"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE="doc examples"

DOCS="README"

src_install() {
	if use doc;then
	   DOCS="${DOCS} docs/*"
	fi

	distutils_src_install

	if use examples;then
	   docinto examples
	   dodoc examples/* || die "dodoc examples code failed"
	fi
}
