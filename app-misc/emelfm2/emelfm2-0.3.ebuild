# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="A file manager that implements the popular two-pane design based on gtk+-2"
HOMEPAGE="http://emelfm2.net/"
SRC_URI="http://emelfm2.net/rel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="unicode fam"

DEPEND=">=x11-libs/gtk+-2.6
		fam? ( virtual/fam )"
RDEPEND=${DEPEND}

src_compile() {
	local myconf

	if use unicode; then
		myconf="FILES_UTF8ONLY=1"
	fi

	if use fam; then
		if has_version "app-admin/gamin"; then
			myconf="${myconf} USE_GAMIN=1"
		else
			myconf="${myconf} USE_FAM=1"
		fi
	else
		myconf="${myconf} USE_FAM=0"
	fi

	# CC= looks bad with CFLAGS, instead the Makefile should be patched
	emake \
		ICONDIR="/usr/share/pixmaps" \
		PREFIX="/usr" \
		CC="$(tc-getCC) ${CFLAGS}" \
		${myconf} || die "emake failed"
}

src_install() {
	dodir /usr/bin

	emake \
		ICONDIR="${D}/usr/share/pixmaps" \
		PREFIX="${D}/usr" \
		install || die "emake install failed"

	prepalldocs
}

