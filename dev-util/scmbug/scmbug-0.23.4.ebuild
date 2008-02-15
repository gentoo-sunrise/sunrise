# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P="SCMBUG_RELEASE_${PV//./-}"

DESCRIPTION="integrates verion control system with bug trackers"
HOMEPAGE="http://www.mkgnu.net/?q=scmbug"
SRC_URI="http://files.mkgnu.net/files/scmbug/${MY_P}/source/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="doc? ( media-gfx/transfig )"
RDEPEND="dev-lang/perl
		dev-perl/Mail-Sendmail"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Remove threads dependency which is not necessary on Linux (uses fork)
	epatch "${FILESDIR}/${P}-threads.patch"
}

src_compile() {
	local myconf
	use doc || myconf="${myconf} --without-doc"

	econf \
		${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
}
