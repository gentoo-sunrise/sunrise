# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

GIZMO_VER="1.0.0.18-1_debian"
SIPPHONE_VER2="0.78.20060211"
SIPPHONE_VER="${SIPPHONE_VER2}-1"

DESCRIPTION="Gizmo is a P2P-VoiceIP client"
HOMEPAGE="http://www.gizmoproject.com/"
SRC_URI="http://www.gizmoproject.com/GizmoDownload/gizmo-project_${GIZMO_VER}_i386.deb
	http://www.gizmoproject.com/GizmoDownload/libsipphoneapi_alsa_${SIPPHONE_VER}_i386.deb"
LICENSE="gizmoproject-eula"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror strip"
QA_TEXTREL_x86="opt/gizmo/libsipphoneapi.so.0.78.20060211"

RDEPEND="dev-libs/atk
	dev-libs/expat
	dev-libs/glib
	dev-libs/libxml2
	dev-libs/openssl
	gnome-base/gconf
	gnome-base/libglade
	gnome-base/orbit
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/tiff
	net-misc/mDNSResponder
	>=x11-libs/gtk+-2
	|| (
		( x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXft
		x11-libs/libXrender )
		<virtual/x11-7.0 )
	x11-libs/pango
	media-libs/jpeg
	media-libs/libpng
	>=net-misc/curl-7.15.1-r1
	sys-libs/zlib"

S=${WORKDIR}

src_unpack() {
	for i in ${A} ; do
		ar x $i
		tar xzf data.tar.gz
	done
}

src_install() {
	exeinto /opt/gizmo
	doexe usr/bin/gizmo usr/lib/libsipphone{sslops,}api.so.${SIPPHONE_VER2}

	dosym libsipphonesslopsapi.so.${SIPPHONE_VER2} /opt/gizmo/libsipphonesslopsapi.so
	dosym libsipphoneapi.so.${SIPPHONE_VER2} /opt/gizmo/libsipphoneapi.so

	# compat symlinks
	dosym /usr/$(get_libdir)/libexpat.so /opt/gizmo/libexpat.so.1
	dosym /usr/$(get_libdir)/libtiff.so /opt/gizmo/libtiff.so.4

	dodoc usr/share/doc/gizmo-project/*
	docinto libsipphoneapi
	dodoc usr/share/doc/libsipphoneapi/*

	insinto /opt/gizmo
	doins -r usr/share/libsipphoneapi
	insinto /opt/gizmo/data
	doins -r usr/share/gizmo/*

	# make gizmo use /opt
	dodir /usr/share
	dosym /opt/gizmo/data /usr/share/gizmo
	dosym /opt/gizmo/libsipphoneapi /usr/share/libsipphoneapi

	make_wrapper ${PN} ./${PN} /opt/${PN} . || die "make_wrapper failed"

	domenu usr/share/applications/gizmo.png
	doicon usr/share/pixmaps/gizmo.png
}
