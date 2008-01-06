# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A free UPnP A/V & DLNA Media Server for Linux"
HOMEPAGE="http://ushare.geexbox.org/"
SRC_URI="http://ushare.geexbox.org/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="dlna nls"

DEPEND="dlna? ( media-libs/libdlna ) net-libs/libupnp"
RDEPEND="${DEPEND}"

src_compile() {
	local myconf="$(use_enable dlna) --prefix=/usr --sysconfdir=/etc"
	use nls  || myconf="${myconf} --disable-nls"

	# econf is not valid here
	# ./configure file do not implement --host
	./configure \
		${myconf} \
		|| die "./configure failed"
	emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc README FAQ CHANGELOG
}
