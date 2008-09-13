# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby

DESCRIPTION="Ruby bindings for the taglib, allowing to access MP3, OGG, and FLAC tags"
HOMEPAGE="http://www.hakubi.us/ruby-taglib/"
SRC_URI="http://www.hakubi.us/ruby-taglib/${P}.tar.bz2"
USE_RUBY="ruby18 ruby19"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="media-libs/taglib"

src_install() {
	ruby_src_install
	dodoc README
}
