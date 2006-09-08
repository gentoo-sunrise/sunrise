# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="http://www.10kloc.org/dwm/"
SRC_URI="http://10kloc.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE="savedconfig"

DEPEND="|| ( x11-libs/libX11 <virtual/x11-7 )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-config_mk.patch"
	epatch "${FILESDIR}/${P}-makefile.patch"

	if use savedconfig; then
		local conf root
		[[ -r config.h ]] && rm config.h
		for conf in ${PF} ${P} ${PN}; do
			for root in "${PORTAGE_CONFIGROOT}" "${ROOT}" /; do
				configfile=${root}etc/portage/savedconfig/${conf}.config.h
				if [[ -r ${configfile} ]]; then
					elog "Found your ${configfile} and using it."
					cp ${configfile} "${S}"/config.h
					return 0
				fi
			done
		done
		ewarn "Could not locate user configfile, so we will save a default one."
	fi
}

src_compile() {
	local msg
	use savedconfig && msg=", please check the configfile"
	emake CC=$(tc-getCC) || die "emake failed${msg}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"

	dodoc README
}

pkg_preinst() {
	if use savedconfig; then
		local config_dir="${PORTAGE_CONFIGROOT:-${ROOT}}/etc/portage/savedconfig"
		elog "Saving this build config to ${config_dir}/${PF}.config.h"
		einfo "Read this ebuild for more info on how to take advantage of this option."
		mkdir -p "${config_dir}"
		cp "${S}"/config.h "${config_dir}"/${PF}.config.h
	fi
}

pkg_postinst() {
	einfo "This ebuild has support for user defined configs"
	einfo "Please read this ebuild for more details and re-emerge as needed"
	einfo "if you want to add or remove functionality for ${PN}"
}
