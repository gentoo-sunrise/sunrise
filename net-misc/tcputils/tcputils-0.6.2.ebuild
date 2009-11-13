# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="A small collection of programs to facilitate TCP programming in shell-scripts"
HOMEPAGE="ftp://ftp.lysator.liu.se/pub/unix/tcputils/"
SRC_URI="ftp://ftp.lysator.liu.se/pub/unix/${PN}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

src_prepare() {
	# trivially patch Makefile for using Gentoo CFLAGS etc
	epatch "${FILESDIR}/${P}-Makefile.patch"
}

src_install() {
	dobin tcpconnect tcplisten tcpbug mini-inetd getpeername || die
	doman tcpconnect.1 tcplisten.1 tcpbug.1 mini-inetd.1 getpeername.1 || die
	dodoc README || die
}
