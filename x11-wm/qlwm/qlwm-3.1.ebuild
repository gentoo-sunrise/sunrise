# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

DESCRIPTION="A Qt based window manager"
HOMEPAGE="http://www.mynetcologne.de/~nc-lindenal/qlwm/
http://www.alinden.mynetcologne.de/qlwm/"
SRC_URI="http://www.alinden.mynetcologne.de/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="3"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/qt:3
x11-libs/libX11
x11-libs/libXext"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix path to shared files
	sed -i -e 's!^DEST .*$!DEST = /usr/share/'"${PN}-${SLOT}"'!' "Makefile" \
	   || die "Cannot fix DEST variable for shared files"
	# in the source code, fix path to config files and images
	sed -i -e 's!\bCONFDIR ".*$!CONFDIR "/usr/share/'"${PN}-${SLOT}"'/files/"!' \
	   "src/conf.h" || die "Cannot change CONFDIR in src/conf.h"
	# fixing path/filename to qtconfig
	sed -i -e 's!qtconfig!/usr/qt/3/bin/qtconfig!' "files/menuconfig" \
	   || die "Cannot fix menu entry for qtconfig"
}

src_install() {
	# install binaries with slotted filenames
	newbin src/qlwm qlwm-${SLOT} || die "Cannot install binary qlwm"
	newbin dclock/dclock dclock-${SLOT} || die "Cannot install binary dclock"
	newbin mail/biff biff-${SLOT} || die "Cannot install binary dclock"

	# install man page with slotted filename
	newman qlwm.1 qlwm-${SLOT}.1 || die "Cannot install manual file"

	# renaming defaults file
	mv files/defaults.in files/defaults || die "Cannot rename default config"
	# disable font name entries in default config file
	sed -i -e 's!^\(\S*FontName\S*\)\b!# \1!g;
	           s!^\(Style \)!# \1!g' \
	   files/defaults || die "Cannot fix font names in default configuration"
	# rename entries for dclock and biff to match $SLOT
	sed -i -e 's!\S*\(dclock\|biff\)\b!/usr/bin/\1-'${SLOT}'!g' \
	   files/defaults || die "Cannot fix font names in default configuration"

	# install config files and images
	insinto /usr/share/${PN}-${SLOT}
	doins -r files/ || die "Cannot install shared files"

	# install documentation
	dodoc README CHANGES || die "Cannot install documentation"
}
