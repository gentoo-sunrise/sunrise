# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="GCstar is an application for managing your collections."
HOMEPAGE="http://www.gcstar.org/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="md5 mime zip zlib"

DEPEND="dev-lang/perl
	dev-perl/gtk2-perl
	dev-perl/libwww-perl
	virtual/perl-Time-HiRes
	dev-perl/XML-Parser
	dev-perl/XML-Simple
	dev-perl/Archive-Tar
	md5? ( virtual/perl-Digest-MD5 )
	mime? ( virtual/perl-MIME-Base64 )
	zip? ( dev-perl/Archive-Zip )
	zlib? ( dev-perl/Compress-Zlib )"

RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	sed -i -e 's/.png/.svg/' "${S}/share/applications/${PN}.desktop" || die "sed failed"
}

src_install() {
	./install --prefix="${D}/usr" --nomenu
	doicon "${S}/share/${PN}/icons/${PN}.svg"
	domenu "${S}/share/applications/${PN}.desktop"
}
