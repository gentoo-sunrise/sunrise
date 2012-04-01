# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit rpm versionator

MY_P="${PN}-$(replace_version_separator 3 -)"
MY_PV="$(get_version_component_range 1-3)"

DESCRIPTION="Epson Perfection V500 scanner plugin for SANE 'epkowa' backend."
HOMEPAGE="http://www.avasys.jp/english/linux_e/dl_scan.html"
SRC_URI="
	x86?   ( http://linux.avasys.jp/drivers/iscan-plugins/${PN}/${MY_PV}/${MY_P}.i386.rpm )
	amd64? ( http://linux.avasys.jp/drivers/iscan-plugins/${PN}/${MY_PV}/${MY_P}.x86_64.rpm )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=">=media-gfx/iscan-2.21.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

QA_PRESTRIPPED="/opt/iscan/lib/libesint7C.so.2.0.1 /opt/iscan/lib/libesint7C.so.2 /opt/iscan/lib/libesint7C.so"

src_install() {
	# install scanner firmware
	insinto /opt/iscan/share
	doins "${WORKDIR}"/usr/share/iscan/*
	dosym /opt/iscan/share/esfw7C.bin /usr/share/iscan/esfw7C.bin
	# install scanner plugins
	exeinto /opt/iscan/lib
	doexe "${WORKDIR}/usr/$(get_libdir)/iscan/"*
}

pkg_setup() {
	basecmd="iscan-registry --COMMAND interpreter usb 0x04b8 0x0130 /opt/iscan/lib/libesint7C"
}

pkg_postinst() {
	[[ -n ${REPLACING_VERSIONS} ]] && return

	if [[ ${ROOT} == "/" ]]; then
		eval ${basecmd/COMMAND/add}
	else
		ewarn "Unable to register the plugin and firmware when installing outside of /."
		ewarn "execute the following command yourself:"
		ewarn "${basecmd/COMMAND/add}"
	fi
}

pkg_prerm() {
	[[ -n ${REPLACED_BY_VERSION} ]] && return

	if [[ ${ROOT} == "/" ]]; then
		eval ${basecmd/COMMAND/remove}
	else
		ewarn "Unable to register the plugin and firmware when installing outside of /."
		ewarn "execute the following command yourself:"
		ewarn "${basecmd/COMMAND/remove}"
	fi
}
