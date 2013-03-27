# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit elisp-common multilib

DESCRIPTION="Interactive Javascript Console for Mozilla Applications Developers"
HOMEPAGE="https://github.com/bard/mozrepl/wiki http://addons.mozilla.org/firefox/addon/mozrepl"
SRC_URI="https://github.com/bard/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

DEPEND="emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}
	|| ( www-client/firefox www-client/firefox-bin www-client/conkeror www-client/seamonkey )"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	rm components/Makefile || die
}

src_compile() {
	if use emacs; then
		cd chrome/content || die
		elisp-make-autoload-file
		elisp-compile *.el
	fi
}

src_install() {
	local emid="mozrepl@hyperstruct.net" #test install.rdf during version bumps

	insinto "/usr/share/${P}"
	doins -r ./*

	local MOZ_DIRS=(
		"/usr/$(get_libdir)/firefox"
		"/opt/firefox"
		"/usr/share/conkeror"
		"/usr/$(get_libdir)/seamonkey"
	)

	local i
	for i in ${MOZ_DIRS[@]}
	do
		dosym "/usr/share/${P}" "${i}/extensions/${emid}"
	done

	if use emacs; then
		cd chrome/content || die
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}
