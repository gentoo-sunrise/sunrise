# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="GCstar is an application for managing your collections."
HOMEPAGE="http://www.gcstar.org/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="md5 mime zip zlib"

DEPEND="dev-lang/perl
	dev-perl/gtk2-perl
	dev-perl/libwww-perl
	virtual/perl-Time-HiRes
	dev-perl/XML-Parser
	dev-perl/XML-Simple
	dev-perl/Archive-Tar"

RDEPEND="${DEPEND}
	md5? ( virtual/perl-Digest-MD5 )
	mime? ( virtual/perl-MIME-Base64 )
	zip? ( dev-perl/Archive-Zip )
	zlib? ( dev-perl/Compress-Zlib )"

S=${WORKDIR}/${PN}

src_install() {
	./install --prefix="${D}/usr" --nomenu
	newicon "${S}/share/gcstar/icons/${PN}_64x64.png" ${PN}.png
	domenu "${S}/share/applications/${PN}.desktop"
}
