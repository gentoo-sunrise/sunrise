# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/gnonlin/gnonlin-0.10.5.ebuild,v 1.1 2006/07/21 12:38:27 zaheerm Exp $

SRC_URI="http://gstreamer.freedesktop.org/src/${PN}/${P}.tar.bz2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DESCRIPTION="Gnonlin is a set of GStreamer elements to ease the creation of non-linear multimedia editors."
HOMEPAGE="http://gnonlin.sourceforge.net"
LICENSE="LGPL-2"
SLOT=0.10

S=${WORKDIR}/${P}
RDEPEND=">=media-libs/gstreamer-0.10.9
	 >=media-libs/gst-plugins-base-0.10.9"

DEPEND="${RDEPEND}"

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS README RELEASE INSTALL REQUIREMENTS
}
