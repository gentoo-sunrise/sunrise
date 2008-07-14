# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils eutils

DESCRIPTION="Off-The-Record messaging (OTR) for irssi"
HOMEPAGE="http://irssi-otr.tuxfamily.org"

# This should probably be exported by cmake-utils as a variable
CMAKE_BINARY_DIR="${WORKDIR}"/${PN}_build

MY_PV=v${PV/_/-}
S="${WORKDIR}/irssiotr"

MY_IRSSI_URL="http://svn.irssi.org/cgi-bin/viewvc.cgi/irssi/trunk/src/fe-text"
MY_IRSSI_URLPARMS="revision=4806&root=irssi"
SRC_URI="
	${MY_IRSSI_URL}/mainwindows.h?${MY_IRSSI_URLPARMS}
	${MY_IRSSI_URL}/term.h?${MY_IRSSI_URLPARMS}
	${MY_IRSSI_URL}/statusbar.h?${MY_IRSSI_URLPARMS}
	http://git.tuxfamily.org/irssiotr/irssiotr.git?p=gitroot/irssiotr/irssiotr.git;a=snapshot;h=${MY_PV};sf=tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	net-libs/libotr
	net-irc/irssi"

DEPEND="${RDEPEND}
	dev-libs/glib
	>=dev-util/cmake-2.4.7
	dev-util/pkgconfig
	dev-lang/python"

src_unpack() {
	ln -s "${DISTDIR}/irssiotr.git;a=snapshot;h=${MY_PV};sf=tgz" ${P}.tgz
	unpack ./${P}.tgz

	mkdir -p "${CMAKE_BINARY_DIR}/irssi-private-headers/fe-text"

	# copy prefetched irssi private headers and patch them
	# a bug has been filed to make these public, irssi FS#535
	for privheader in mainwindows.h term.h statusbar.h; do
		cp "${DISTDIR}/${privheader}?${MY_IRSSI_URLPARMS}" \
			"${CMAKE_BINARY_DIR}/irssi-private-headers/fe-text/${privheader}" \
			|| die "failed to copy prefetched irssi private headers"
	done
	cd "${CMAKE_BINARY_DIR}/irssi-private-headers/fe-text"
	epatch "${S}"/privheaders.patch
	mycmakeargs="-DIRSSIOTR_VERSION=${PV} -DDOCDIR=/usr/share/doc/${PF}"
}

src_install() {
	cmake-utils_src_install
	rm "${D}"/usr/share/doc/${PF}/LICENSE
	prepalldocs
}
