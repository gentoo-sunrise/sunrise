# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18"

inherit ruby-ng

DESCRIPTION="RSS/Atom feed aggregator which uploads feeds to an IMAP server"
HOMEPAGE="http://home.gna.org/feed2imap/"
SRC_URI="http://download.gna.org/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-ruby/ruby-feedparser
	dev-ruby/rubymail"

each_ruby_configure() {
	${RUBY} setup.rb config || die
}

each_ruby_install() {
	${RUBY} setup.rb install --prefix="${D}" || die
}

all_ruby_install() {
	dodoc ChangeLog README || die
}
