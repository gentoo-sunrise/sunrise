# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm

MY_PV="${PV}-1"
MY_P="${PN/-bin}-${MY_PV}"

At="${MY_P}.i386.rpm"

DESCRIPTION="live TV on your PC (Switzerland and Denmark only)"
HOMEPAGE="http://zattoo.com/"
SRC_URI="${At}"
DOWNLOAD_URL="https://zattoo.com/downloadlinux"

LICENSE="Zattoo"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

#NOTE: As there is no real documentation, I don't know
#      exactly what dependancies are needed.
#      These are just the ones I came across:
DEPEND=""
RDEPEND=">=sys-libs/glibc-2.4
	x11-libs/gtkglext
	app-crypt/libgssapi
	app-crypt/mit-krb5
	gnome-base/libgnome
	gnome-base/libgnomeui
	media-libs/alsa-lib
	dev-libs/openssl"

RESTRICT="fetch strip"
QA_TEXTRELS="usr/lib/zattoo/*"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please download ${At} from:"
	einfo "${DOWNLOAD_URL}"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	rpm_unpack ${DISTDIR}/${At}
}

src_install() {
	dobin usr/bin/zattoo_player usr/bin/zattood
	insinto /usr/lib/zattoo
	doins usr/lib/zattoo/*
	insinto /usr/share/zattoo_player
	doins -r usr/share/zattoo_player/*
	insinto /usr/share/applications
	doins usr/share/applications/zattoo_player.desktop
}

pkg_postinst() {
	ldconfig /usr/lib/zattoo
}
