# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby

USE_RUBY="ruby18"

DESCRIPTION="A Ruby library for picking random elements and shuffling."
HOMEPAGE="http://chneukirchen.org/blog/static/projects/rand.html"
SRC_URI="http://chneukirchen.org/releases/${P}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.4"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${P}
	[ -f install.rb ] && mv install.rb install.rb.bak
}
