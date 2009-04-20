# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit vim-doc

DESCRIPTION="A small utility which allows debugging from within vim"
HOMEPAGE="http://clewn.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=app-editors/gvim-7.0[netbeans]
	sys-libs/readline"
RDEPEND="${DEPEND}
	sys-devel/gdb"

src_configure() {
	vimdir=/usr/share/vim/vimfiles econf $(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README || die "dodoc failed"
}

pkg_postinst() {
	update_vim_helptags
}
