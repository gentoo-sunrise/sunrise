# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby gems

USE_RUBY="ruby18"

DESCRIPTION="A Ruby implementation of the Flickr API."
HOMEPAGE="http://rubyforge.org/projects/rflickr"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.4
	dev-ruby/mime-types"
RDEPEND="${DEPEND}
	dev-ruby/rake"

pkg_postinst() {
	elog "In order to use this library, you need to have:"
	elog
	elog "1. A Yahoo!/Flickr account."
	elog "2. A Flickr API Key."
	elog "3. A Shared Secret."
	elog
	elog "Visit http://www.flickr.com/services/api/ for more info."
}
