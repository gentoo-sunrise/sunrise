# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Command line utility able to create bootable USB disks"
HOMEPAGE="http://advancemame.sourceforge.net/boot-readme.html"
SRC_URI="mirror://sourceforge/advancemame/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-boot/syslinux"
DEPEND="${RDEPEND}"


src_install() {
	emake DESTDIR="${D}" install || \
		die "installation failed"

	insinto /usr/share/makebootfat
	doins mbrfat.bin || die

	dodoc doc/{authors,history,makebootfat,readme}.txt \
		|| die "nothing to read"
	dohtml doc/{authors,history,makebootfat,readme}.html \
		|| die "no html"
}

