# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby gems eutils

USE_RUBY="ruby18"
MY_P="gd2-${PV}"

DESCRIPTION="Ruby bindings for the GD 2.x graphics library."
HOMEPAGE="http://gd2.rubyforge.org/"
SRC_URI="http://gems.rubyforge.org/gems/${MY_P}.gem"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.4"
RDEPEND="${DEPEND}
	>=media-libs/gd-2.0.0"

pkg_setup() {
	if ! built_with_use media-libs/gd truetype ; then
		eerror "You need to build media-libs/gd with USE=truetype enabled."
		die "gd without truetype-support detected."
	fi
}
