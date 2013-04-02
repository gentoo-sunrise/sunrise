# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils git-2

EGIT_REPO_URI="git://github.com/zsh-users/zsh-history-substring-search.git"
DESCRIPTION="Fish shell like history substring search for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-history-substring-search"

LICENSE="BSD"
SLOT="0"

RDEPEND="app-shells/zsh"

src_prepare() {
	epatch_user
}

src_install() {
	dodoc *.md
	insinto /usr/share/zsh/site-contrib/${PN}
	doins zsh-history-substring-search.zsh
}

pkg_postinst() {
	[[ -n "${REPLACING_VERSIONS}" ]] && return
	elog "In order to use ${CATEGORY}/${PN} add"
	elog ". /usr/share/zsh/site-contrib/${PN}/zsh-history-substring-search.zsh"
	elog "at the end of your ~/.zshrc"
	elog "For testing, you can also execute the above command in your zsh."
	elog "If you want to use zsh-syntax-highlighting along with this "
	elog "script, then make sure that you load it before you load this "
	elog "script:"
	elog ". /usr/share/zsh/site-contrib/${PN}/zsh-syntax-highlighting.zsh"
	elog ". /usr/share/zsh/site-contrib/${PN}/zsh-history-substring-search.zsh"
}
