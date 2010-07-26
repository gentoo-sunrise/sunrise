# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit base versionator

DESCRIPTION="A Remote Desktop Protocol Client, forked from rdesktop"
HOMEPAGE="http://freerdp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/$(get_version_component_range 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="alsa cups iconv ipv6 largefile X"

DEPEND="
	>=dev-libs/openssl-0.9.8a
	x11-libs/libX11
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	iconv? ( virtual/libiconv )"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	# openssl is mandatory for now. Building without it 
	# is strongly discouraged according to upstream.
	# Warning: Do not trust "./configure --help"
	# it's wrong sometimes - esp. in --enable/--with parts...
	econf \
		--with-crypto=openssl \
		$(use_with alsa sound alsa) \
		$(use_with cups printer cups) \
		$(use_enable iconv) \
		$(use_enable ipv6) \
		$(use_enable largefile) \
		$(use_with X x)
}
