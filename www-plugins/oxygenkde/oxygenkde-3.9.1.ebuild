# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit mozextension multilib versionator

MY_P="OxygenKDE_$(replace_all_version_separators '_')"

DESCRIPTION="Oxygen style for Firefox"
HOMEPAGE="http://kde-look.org/content/show.php?content=117962"
SRC_URI="http://oxygenkde.altervista.org/download/${MY_P}.xpi"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_unpack() {
	xpi_unpack "${MY_P}.xpi"
	xpi_unpack "./${MY_P}/oxykdeopt.xpi" "./${MY_P}/oxykdetheme.xpi"
}

src_prepare() {
	OPT_EMID="{c2a3f51e-2920-4eab-9008-1bcb44d21d57}"
	THEME_EMID="{C1F83B1E-D6EE-11DE-B441-1AD556D89593}"
	mv oxykdeopt ${OPT_EMID} || die
	mv oxykdetheme ${THEME_EMID} || die
}

src_install() {
	insinto /usr/$(get_libdir)/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
	doins -r ${OPT_EMID} ${THEME_EMID}
	dohtml -r ${OPT_EMID}/chrome/oxygenkdeoptions/content/page/*
}