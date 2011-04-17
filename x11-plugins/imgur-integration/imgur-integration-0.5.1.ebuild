# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_P=imgur-${PV}

DESCRIPTION="A command-line utility and media-gfx/eog plugin for uploading to imgur.com"
HOMEPAGE="https://github.com/tthurman/imgur-integration"
SRC_URI="http://www.chiark.greenend.org.uk/~tthurman/imgur/${MY_P}.tar.gz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="eog"

RDEPEND="sys-apps/dbus
	dev-libs/dbus-glib
	>=dev-libs/glib-2.24
	net-misc/curl
	eog? ( media-gfx/eog )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		--disable-libsocialweb \
		--disable-libsharing \
		$(use_enable eog)
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS NEWS README

	# icon is useless without the eog plugin
	use eog || rm -rf "${D}"/usr/share/pixmaps
}

pkg_postinst() {
	if use eog; then
		elog "Please note that in order to use the eog plugin, you have"
		elog "to first enable it in [Edit -> Preferences -> Plugins]."
	fi
}
