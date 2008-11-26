# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby

DESCRIPTION="Ruby library for parsing RSS and Atom feeds"
HOMEPAGE="http://home.gna.org/ruby-feedparser/"
SRC_URI="http://download.gna.org/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
USE_RUBY="ruby18 ruby19"

src_install() {

${RUBY} setup.rb install --prefix="${D}" "$@" \
${RUBY_ECONF} || die "setup.rb install failed"

cd "${S}"
dodoc ChangeLog README

}
