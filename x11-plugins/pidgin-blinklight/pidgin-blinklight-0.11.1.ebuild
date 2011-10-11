# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils #linux-info

MY_P=${PN}_${PV}
DESCRIPTION="Blinks your ThinkPad's ThinkLight upon new messages"
HOMEPAGE="http://www.joachim-breitner.de/blog/archives/239-gaim-thinklight-pidgin-blinklight.html"
SRC_URI="mirror://debian/pool/main/p/${PN}/${MY_P}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="net-im/pidgin"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog README TODO VERSION"

# Don't know if checking kernel config does make sense here. The modules are needed, of course
#CONFIG_CHECK="THINKPAD_ACPI ASUS_LAPTOP" # deprecated: ACPI_ASUS (since 2.6.19) IBM-ACPI (since 2.6.22)
#pkg_pretend() {
#	
#}

src_prepare() {
	epatch "${FILESDIR}"/fix-paths.patch
#	epatch "${FILESDIR}"/new-acpi-path.patch # does not work, blinklight just goes on and stays on
}

pkg_postinst() {
	[[ -f "/proc/acpi/ibm/light" ]] || [[ -f "/proc/acpi/asus/mled" ]] || [[ -f "/sys/class/leds/asus:phone/brightness" ]] || ewarn "It seems you have not built-in or loaded the modules for the acpi subsystems that provide access to the blinklight via filesystem."
}
