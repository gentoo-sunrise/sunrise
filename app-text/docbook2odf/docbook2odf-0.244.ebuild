# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="A toolkit that automaticaly converts DocBook to OASIS OpenDocument"
HOMEPAGE="http://open.comsultia.com/docbook2odf/"
SRC_URI="http://open.comsultia.com/${PN}/dwn/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	>=app-text/docbook2odf-xsl-stylesheets-0.244
	>=dev-lang/perl-5.8
	|| ( >=dev-perl/XML-Sablot-1.01
		 >=dev-libs/libxslt-1.1 )
	>=media-gfx/imagemagick-6.2
	|| ( >=dev-perl/Archive-Zip-1.1
		 >=app-arch/zip-2.3 )
"

src_install() {
	if use examples; then
		docinto examples
		dodoc examples/* || die "Could not install examples"
	fi

	domenu bindings/desktop/*.desktop || die

	doman docs/docbook2odf.1 || die

	dobin utils/docbook2odf \
		|| die "Could not install the executable"
}
