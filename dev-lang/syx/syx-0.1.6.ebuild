# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Open source implementation of the Smalltalk-80 programming language."
HOMEPAGE="http://syx.googlecode.com"
SRC_URI="http://syx.googlecode.com/files/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gmp readline gtk X debug profile"

RDEPEND="gmp? ( dev-libs/gmp )
	readline? ( sys-libs/readline )
	gtk? ( >=x11-libs/gtk+-2.12 )
	X? ( x11-libs/libX11 )"

src_compile() {
	local myconf="$(use_enable gtk)
			$(use_enable readline)
			$(use_enable X x11)
			$(use_enable profile)
			$(use_with gmp)"

	use debug && myconf="${myconf} --enable-debug=info"

	econf ${myconf} || die "Configure failed"

	emake || die "Compile failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README ChangeLog TODO
}
