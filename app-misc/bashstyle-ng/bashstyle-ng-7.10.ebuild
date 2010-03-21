# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils gnome2

DESCRIPTION="A graphical tool for changing the Bashs behaviour"
HOMEPAGE="http://www.nanolx.org/"
SRC_URI="http://download.tuxfamily.org/bashstyleng/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acpi dmi doc pci pdf usb"

DEPEND="x11-libs/vte[python]
	sys-devel/gettext
	acpi? ( sys-power/acpi )
	dmi? ( sys-apps/dmidecode )
	pci? ( sys-apps/pciutils )
	pdf? ( app-text/ghostscript-gpl )
	usb? ( sys-apps/usbutils )"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog README TODO"

src_prepare() {
	epatch "${FILESDIR}/${P}-gconf-update.patch"
}

src_install() {
	if use doc; then
		dohtml documentation/* || die "documentation installation failed"
	fi
	gnome2_src_install
}
