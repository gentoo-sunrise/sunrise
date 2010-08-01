# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator

MY_PV=$(replace_all_version_separators "-")
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Microcode for AMD x10h and x11h gen processors"
HOMEPAGE="http://www.amd64.org/support/microcode.html"
SRC_URI="http://www.amd64.org/pub/microcode/${MY_P}.tar"

LICENSE="amd-ucode"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /lib/firmware/amd-ucode
	doins microcode_amd.bin || die "doins failed"
	}

pkg_postinst() {
	elog "Remember to enable microcode support in your kernel or load its module."
	}
