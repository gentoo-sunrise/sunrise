# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="Markdown_${PV}"

DESCRIPTION="A text-to-HTML conversion tool for web writers."
HOMEPAGE="http://daringfireball.net/projects/markdown/"
SRC_URI="http://daringfireball.net/projects/downloads/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=dev-lang/perl-5.6.0
	virtual/perl-Digest-MD5"

S="${WORKDIR}/${MY_P}"

src_install() {
	dobin Markdown.pl
	dosym Markdown.pl /usr/bin/markdown
	dodoc 'Markdown Readme.text'
}
