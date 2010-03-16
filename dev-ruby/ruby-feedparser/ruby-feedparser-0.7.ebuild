# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18 ruby19"

inherit ruby-ng

DESCRIPTION="Ruby library for parsing RSS and Atom feeds"
HOMEPAGE="http://home.gna.org/ruby-feedparser/"
SRC_URI="http://download.gna.org/${PN}/${P}.tgz"

LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

each_ruby_src_install() {
	${RUBY} setup.rb install --prefix="${D}" "$@" \
		${RUBY_ECONF} || die "setup.rb install failed"
}

all_ruby_src_install() {
	dodoc ChangeLog README || die
}