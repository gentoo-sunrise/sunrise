# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_EXTRAINSTALL="hostmap.conf discovery dictionaries extra"
RUBY_FAKEGEM_BINWRAP="hostmap"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="doc/Changelog.txt doc/README.pdf doc/THANKS.txt"

inherit ruby-fakegem

DESCRIPTION="Automatic hostname and virtual hosts discovery tool written in Ruby"
HOMEPAGE="http://hostmap.lonerunners.net/"
SRC_URI="http://update.lonerunners.net/software/download/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/net-dns
	dev-ruby/plugman"

all_ruby_prepare() {
	mkdir bin || die
	mv hostmap.rb bin/hostmap || die
}
