# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="UDP-based FTP client and server with multicast"
HOMEPAGE="http://www.tcnj.edu/~bush/uftp.html"
SRC_URI="http://www.tcnj.edu/~bush/${P}.tar"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare()	{
	epatch "${FILESDIR}/${P}-hardcoded.patch"
}

src_compile()	{
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install()	{
	dobin uftp || die "dobin failed"
	dosbin uftpd || die "dosbin failed"
	doman uftp.1 uftpd.1 || die "doman failed"
	newinitd "${FILESDIR}"/uftpd.init uftpd || die "newinitd failed"
	newconfd "${FILESDIR}"/uftpd.conf uftpd || die "newconfd failed"
	diropts -o nobody
	keepdir /var/log/uftpd || die "dodir failed"
	dodir /var/run/uftpd || die "dodir run failed"
	keepdir /var/tmp/uftpd || die "dodir tmp failed"
}
