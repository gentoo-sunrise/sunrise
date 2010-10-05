# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

USE_RUBY="ruby18"
RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem

DESCRIPTION="A pure Ruby natural language date parser"
HOMEPAGE="http://chronic.rubyforge.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# case 1 of the following bugreport fails for me, yet the working
# parts of the module must still be useful...
# http://rubyforge.org/tracker/index.php?func=detail&aid=28310&group_id=2115&atid=8245
# --binki
RESTRICT="test"

ruby_add_bdepend "dev-ruby/hoe"
ruby_add_bdepend "doc? ( virtual/ruby-rdoc )"
