# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit tla

DESCRIPTION="tla-tools is a package of helpful commands to use with the tla program."
HOMEPAGE="http://www.gnuarch.org/gnuarchwiki/tla-tools"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-util/tla"

ETLA_VERSION="miles@gnu.org--2006/tla-tools--devo--0"
ETLA_ARCHIVES="http://mirrors.sourcecontrol.net/miles@gnu.org--2006"

src_unpack() {
	tla_src_unpack
	cp -r "${DISTDIR}"/tla-tools--devo--0--patch-*/* "${S}"
}

src_compile() {
	./configure \
		--prefix /usr || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
