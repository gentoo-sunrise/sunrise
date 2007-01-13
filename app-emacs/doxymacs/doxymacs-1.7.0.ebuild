# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit elisp

DESCRIPTION="Doxygen editing minor mode"
HOMEPAGE="http://doxymacs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/emacs
	>=dev-libs/libxml2-2.6.13"
# w3 is only needed for older emacsen, as URL package is part of >=emacs-22
RDEPEND="${DEPEND}
	|| ( app-emacs/w3 >=app-editors/emacs-cvs-22 >=app-editors/emacs-22 )"

SITEFILE="${FILESDIR}/50doxymacs-gentoo.el"
DOCS="AUTHORS ChangeLog COPYING INSTALL NEWS README TODO"

src_compile() {
	econf \
		--with-datadir="${SITELISP}/${PN}" \
		--with-lispdir="${SITELISP}/${PN}" \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake \
		prefix="${D}/usr" \
		datadir="${D}/${SITELISP}/${PN}" \
		lispdir="${D}/${SITELISP}/${PN}" \
		install \
		|| die "emake install failed"

	elisp-site-file-install "${SITEFILE}"

	dodoc ${DOCS}
}
