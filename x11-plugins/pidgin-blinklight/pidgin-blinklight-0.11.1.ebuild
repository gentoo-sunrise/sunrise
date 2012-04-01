# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils linux-info

DESCRIPTION="Blinks your ThinkPad's ThinkLight upon new messages"
HOMEPAGE="http://www.joachim-breitner.de/blog/archives/239-gaim-thinklight-pidgin-blinklight.html"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-im/pidgin"
RDEPEND="${DEPEND}"

DOCS="AUTHORS ChangeLog README TODO VERSION"

pkg_pretend() {
	local acpi_modules="THINKPAD_ACPI ASUS_LAPTOP ACPI_ASUS IBM-ACPI"
	local acpi_module_present=
	if linux_config_exists; then
		for config in ${acpi_modules}; do
			linux_chkconfig_present ${config} && acpi_module_present=true
		done
	fi
	if ! [[ ${acpi_module_present} ]]; then
		ewarn "Could not find one of the required acpi modules in your kernel config,"
		ewarn "Please enable one of the following:"
		ewarn "$acpi_modules"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/fix-paths.patch
}
