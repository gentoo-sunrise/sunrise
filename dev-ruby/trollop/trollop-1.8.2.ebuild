# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby gems

DESCRIPTION="Advanced commandline option parser with implicit --help generator."
HOMEPAGE="http://trollop.rubyforge.org"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
USE_RUBY="any"
DEPEND="virtual/ruby"
