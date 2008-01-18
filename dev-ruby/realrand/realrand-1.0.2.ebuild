# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="Generate real random numbers in Ruby."
HOMEPAGE="http://realrand.rubyforge.org/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.4"
RDEPEND="${DEPEND}"

pkg_postinst() {
	elog "All the HTTP services supported and used by this library are"
	elog "offered for free by their respective owners. Please have a look at"
	elog "their websites to make sure you follow their terms of use."
	elog
	elog "http://www.random.org/"
	elog "http://www.fourmilab.ch/hotbits/"
	elog "http://random.hd.org/"
}
