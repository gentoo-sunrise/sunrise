# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

MY_PN="WritersCafe"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A toolkit for fiction writers"
HOMEPAGE="http://www.writerscafe.co.uk"
SRC_URI="amd64? ( http://www.writerscafe.co.uk/${MY_P}-x86_64.tar.gz )
	x86? ( http://www.writerscafe.co.uk/${MY_P}-i386.tar.gz )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 -*"
IUSE=""

RDEPEND="x11-libs/gdk-pixbuf[tiff,jpeg]
	x11-libs/gtk+:2
	x11-libs/libXinerama
	x11-libs/pango"

src_unpack() {
	default
	mkdir ${P} ; cd ${P} || die
	unpack ./../"${MY_PN}Data.tar.gz"
}

src_prepare() {
	# fix desktop-file paths
	sed -i "s:/usr/share/${PN}2/${PN}:/usr/bin/${PN}:" \
		${PN}2.desktop || die
}

src_install() {
	local dir="/opt/${MY_PN}"

	# install program files
	insinto "${dir}"
	doins -r .
	fperms 0755 "${dir}"/${PN}

	# install icon
	newicon appicons/${PN}48x48.png ${PN}2.png

	# install desktop-file
	domenu ${PN}2.desktop

	# install startscript
	make_wrapper ${PN} ./${PN} "${dir}"
}
