# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="File manager written using GTK+ and C++"
HOMEPAGE="http://atol.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}_src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome"

RDEPEND=">=x11-libs/gtk+-2.6"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {
	unpack ${A} && cd ${S}

	# Respect CFLAGS and don't use --as-needed by default
	epatch "$FILESDIR/${P}-CFLAGS.patch"

	if ! use gnome; then
		# Comment variable in the Makefile if we don't have gnome
		sed -i -e 's/HAVE_GNOME_VFS=1/#HAVE_GNOME_VFS=1/g' Makefile || \
			die "sed failed"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc readme.txt
}
