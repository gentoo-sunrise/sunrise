# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=4

USE_RUBY="ruby18"

inherit ruby-fakegem

DESCRIPTION="Console screencasting tool"
HOMEPAGE="http://shelr.tv/"
SRC_URI="https://github.com/antono/${PN}/tarball/v${PV} -> ${P}.tar.gz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	dev-ruby/json
"

all_ruby_unpack() {
	unpack ${A}
	mv *-${PN}-* "${S}" || die
}

all_ruby_install() {
	all_fakegem_install
	doman ${PN}.1
}
