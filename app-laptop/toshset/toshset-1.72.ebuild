# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Utility to modify HCI/SCI controls on Toshiba Laptops"
HOMEPAGE="http://www.schwieters.org/toshset http://packages.ubuntulinux.org/feisty/utils/toshset"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/t/toshset/toshset_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
#	epatch "${DISTDIR}/toshset_${PV}-2ubuntu1.diff"
	sed -i 's/CFLAGS = -march=i486 \(-Wall @OS_CFLAGS@ @DEBUGFLAGS@\)/CFLAGS := \1 ${CFLAGS}/' "${S}/Makefile.in" || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
