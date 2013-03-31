# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/syslinux/syslinux-5.01.ebuild,v 1.1 2013/02/18 15:22:00 chithanh Exp $

EAPI=5

DESCRIPTION="Displays boot information in a convenient format to troubleshoot booting problems"
HOMEPAGE="http://bootinfoscript.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-shells/bash"
DEPEND="${RDEPEND}"
S="${WORKDIR}"

src_install() {
   dobin bootinfoscript
   dodoc README CHANGELOG
}