# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils

DESCRIPTION="GTK based presentation viewer application which uses Keynote like multi-monitor output"
HOMEPAGE="http://westhoffswelt.de/projects/pdf_presenter_console.html"
SRC_URI="http://westhoffswelt.de/data/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	app-text/poppler[cairo]"
# There's no glib useflag, but it seems like poppler doesn't build glib bindings without cairo
DEPEND=">=dev-lang/vala-0.11.0
	${RDEPEND}"

S=${WORKDIR}/Pdf-Presenter-Console-${PV}

src_configure() {
	# To get the most current valac executable we need some dirty parsing here (get "0.14" from "dev-lang/vala-0.14.0")
	local myvalaver="$(best_version dev-lang/vala | sed -e 's@dev-lang/vala-\([0-9]*\.[0-9]*\)\..*@\1@g')"
	local myvalac="$(type -p valac-${myvalaver})"
	[[ -x "${myvalac}" ]] || die "Vala compiler ${myvalac} not found"

	local mycmakeargs=("-DVALA_EXECUTABLE=${myvalac}")
	cmake-utils_src_configure
}
