# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="A Ruby port of the PHP SmartyPants library."
HOMEPAGE="http://chneukirchen.org/blog/static/projects/rubypants.html"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="test"

DEPEND=">=dev-lang/ruby-1.8.4"
RDEPEND=${DEPEND}

pkg_postinst() {
	einfo "RubyPants uses an API compatible with RedCloth and BlueCloth that"
	einfo "differs with that of SmartyPants."
}
