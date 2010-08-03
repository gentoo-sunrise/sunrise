# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README PlugMan.pdf"

inherit ruby-fakegem

DESCRIPTION="A simple plugin manager for ruby"
HOMEPAGE="http://rubyforge.org/projects/plugman/"
SRC_URI="http://rubyforge.org/frs/download.php/33561/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	#Normal directory structure helps.
	mv src lib || die
	sed -i 's|src/|lib/|g' Rakefile || die "sed failed"
}
