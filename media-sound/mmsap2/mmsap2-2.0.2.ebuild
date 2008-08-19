# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Comfortable SAP player based on ASAP library."
HOMEPAGE="http://mmsap.sourceforge.net/"
SRC_URI="mirror://sourceforge/mmsap/${PN}_${PV}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.10
	dev-libs/dbus-glib
	>=gnome-base/libglade-2.6
	media-libs/alsa-lib"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${PN}"

src_compile(){
	cd asap-1.2.0
	econf
	emake lib || die "emake lib failed"
	cd ..
	emake CONF="Release" || die "emake failed"
}

src_install() {
	dobin dist/Release/GNU-Linux-x86/${PN} || die "install failed"
}
