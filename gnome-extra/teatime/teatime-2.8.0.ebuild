# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit gnome2 eutils

DESCRIPTION="A GNOME panel applet that reminds you when your tea is ready"
HOMEPAGE="http://det.cable.nu/teatime/index.rbx"
SRC_URI="mirror://debian/pool/main/t/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	|| ( media-plugins/gst-plugins-gconf
	     media-libs/gstreamer )
	gnome-base/gnome-vfs:2
	gnome-base/gnome-panel
	dev-libs/libxml2"
RDEPEND=${DEPEND}

S=${WORKDIR}/${PN}_applet_2-${PV}

src_prepare() {
	epatch \
		"${FILESDIR}"/teatime-2.8.0-adding-slash-for-pixmaps-dir.patch \
		"${FILESDIR}"/03_libexec.patch \
		"${FILESDIR}"/04_intltool.patch \
		"${FILESDIR}"/70_cs.patch \
		"${FILESDIR}"/80_implicit.patch \
		"${FILESDIR}"/81_implicit_vfs.patch \
		"${FILESDIR}"/90_gst.patch \
		"${FILESDIR}"/91_gst_enable_playing.patch
	gnome2_omf_fix
}
