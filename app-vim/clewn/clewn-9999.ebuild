# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils subversion vim-doc

DESCRIPTION="A small utility which allows debugging from within vim"
HOMEPAGE="http://clewn.sourceforge.net/"
ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/${PN}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
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
	dodoc ChangeLog README
}

pkg_postinst() {
	update_vim_helptags
}
