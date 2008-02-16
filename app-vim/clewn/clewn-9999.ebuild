# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion vim-doc

DESCRIPTION="A small utility which allows debugging from within vim"
HOMEPAGE="http://clewn.sourceforge.net/"
ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/${PN}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND=">=app-editors/gvim-7.0
	sys-libs/readline"
RDEPEND="${DEPEND}
	sys-devel/gdb"

pkg_setup() {
	if ! built_with_use app-editors/gvim netbeans ; then
		eerror "Please (re)emerge gvim with netbeans USE flag on before "
		eerror "emerging clewn"
		die "please (re)emerge app-editors/gvim with USE='netbeans'"
	fi
}

src_compile() {
	vimdir=/usr/share/vim/vimfiles econf $(use_enable debug)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README
}

pkg_postinst() {
	update_vim_helptags
}
