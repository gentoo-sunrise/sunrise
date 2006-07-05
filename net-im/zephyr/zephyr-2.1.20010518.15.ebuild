# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator
DESCRIPTION="The original \"Instant Message\" system client"

HOMEPAGE="http://packages.debian.org/unstable/source/zephyr"

MY_PV=$(replace_version_separator 3 '.SNAPSHOT_')
MY_PV=${MY_PV%%_*}

SRC_URI="http://ftp.debian.org/debian/pool/main/z/zephyr/${PN}_${MY_PV}.orig.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="krb4 X"

DEPEND="krb4? ( app-crypt/mit-krb5 )
	sys-libs/ncurses
	sys-libs/readline
	X? || (
		virtual/x11
		(
			x11-libs/libSM
			x11-libs/libXau
			x11-libs/libXdmcp
			x11-libs/libXmu
			x11-libs/libXpm
		)
	)"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-debian.patch
}

src_compile() {
	econf $(use_with krb4 krb4=/usr) $(use_with X x) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "make install failed"

	newinitd ${FILESDIR}/zhm.initd zhm
	newconfd ${FILESDIR}/zhm.confd zhm
}
