# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A podcast client for the command-line written in Ruby."
HOMEPAGE="http://podcatcher.rubyforge.org/"
SRC_URI="http://rubyforge.org/frs/download.php/12967/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="bittorrent"

DEPEND=">=dev-lang/ruby-1.8.2
	bittorrent? ( dev-ruby/rubytorrent )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
	dobin podcatcher
	dodoc README sample.opml sample.pcast
}
