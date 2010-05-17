# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
inherit distutils

DESCRIPTION="Simple LaTeX editor for GTK+ users"
HOMEPAGE="http://gummi.midnightcoding.org"
SRC_URI="http://dev.midnightcoding.org/redmine/attachments/download/25/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/pygtksourceview-2.4.0:2
	dev-python/python-poppler
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	x11-libs/gtk+:2
	x11-libs/pango"

pkg_postinst() {
	elog "Gummi >=0.4.8 supports spell checking through gtkspell. You are"
	elog "required to have dev-python/gtkspell-python installed to use this"
	elog "feature. Support for additional languages can be enabled by"
	elog "installing myspell-** packages for your language of choice."
}
