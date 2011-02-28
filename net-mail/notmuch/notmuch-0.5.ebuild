# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
PYTHON_DEPEND="python? 2:2.6"
SUPPORT_PYTHON_ABIS="1"

inherit bash-completion distutils elisp-common eutils

DESCRIPTION="Thread-based email index, search and tagging"
HOMEPAGE="http://notmuchmail.org/"
SRC_URI="http://notmuchmail.org/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+emacs python zsh-completion"

CDEPEND="emacs? ( virtual/emacs )
	dev-libs/gmime:2.4
	sys-libs/talloc
	dev-libs/xapian"

DEPEND="${CDEPEND}
	dev-util/pkgconfig"

RDEPEND="${CDEPEND}
	zsh-completion? ( app-shells/zsh-completion )"

RESTRICT_PYTHON_ABIS="3.*"


src_prepare() {
	if ! use emacs; then
		ewarn "The default UI is provided as an emacs module."
		ewarn "You should set USE=emacs if you want to use ${PN} as a MUA."
	fi

	epatch "${FILESDIR}/configure_add_option.patch"

	if use python ; then
		cd bindings/python || die "bindings/python not found"
		LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${S}/lib distutils_src_prepare
	fi
}

src_configure() {
	econf \
		"--emacslispdir=${SITELISP}/${PN}" \
		"--bashcompletiondir=/usr/share/bash-completion" \
		"--zshcompletiondir=/usr/share/zsh/site-functions" \
		$(use_with bash-completion) \
		$(use_with emacs) \
		$(use_with zsh-completion)
}

src_compile() {
	default

	if use python ; then
		cd bindings/python || die "bindings/python not found"
		LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${S}/lib distutils_src_compile
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc AUTHORS NEWS README TODO || die "dodoc failed"

	if use emacs ; then
		elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el" || die
	fi

	if use python ; then
		cd bindings/python || die "bindings/python not found"
		LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${S}/lib distutils_src_install
	fi
}

pkg_postinst() {
	use python && distutils_pkg_postinst
	use emacs && elisp-site-regen
	bash-completion_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
	use emacs && elisp-site-regen
}
