# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby

DESCRIPTION="Ruby interface to GnuPG Made Easy (GPGME)"
HOMEPAGE="http://ruby-gpgme.rubyforge.org/"
SRC_URI="http://rubyforge.org/frs/download.php/51466/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

USE_RUBY="ruby18 ruby19"
DEPEND=">=dev-lang/ruby-1.8
	app-crypt/gpgme"
RDEPEND="${DEPEND}"

src_install() {
	ruby_src_install
	if use examples; then
		docinto examples
		dodoc examples/* || die "Failed to install examples"
	fi
}
