# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Open source command-line RTMP client intended to stream audio or video flash content"
HOMEPAGE="http://rtmpdump.mplayerhq.hu/"
SRC_URI="http://rtmpdump.mplayerhq.hu/download/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnutls polarssl ssl"

DEPEND="ssl? (
		gnutls? ( net-libs/gnutls )
		polarssl? ( !gnutls? ( net-libs/polarssl ) )
		!gnutls? ( !polarssl? ( dev-libs/openssl ) )
	)
	sys-libs/zlib"
RDEPEND="${DEPEND}"

pkg_setup() {
	if ! use ssl && ( use gnutls ||	use polarssl ) ; then
		ewarn "USE='gnutls polarssl' are ignored without USE='ssl'."
		ewarn "Please review the local USE flags for this package."
	fi
}

src_prepare() {
	# fix Makefile ( bug #298535 and bug #318353 )
	sed -i 's/\$(MAKEFLAGS)//g' Makefile \
		|| die "failed to fix Makefile"
}

src_compile() {
	local crypto=""
	if use ssl ; then
		if use gnutls ;	then
			crypto="GNUTLS"
		elif use polarssl ; then
			crypto="POLARSSL"
		else
			crypto="OPENSSL"
		fi
	fi

	emake CC=$(tc-getCC) LD=$(tc-getLD) \
		OPT="${CFLAGS}" XLDFLAGS="${LDFLAGS}" CRYPTO="${crypto}" posix || die "emake failed"
}

src_install() {
	dobin rtmpdump rtmpsuck rtmpsrv rtmpgw || die "dobin failed"
	dodoc README ChangeLog rtmpdump.1.html rtmpgw.8.html || die "dodoc failed"
	doman rtmpdump.1 rtmpgw.8 || die "doman failed"
}
