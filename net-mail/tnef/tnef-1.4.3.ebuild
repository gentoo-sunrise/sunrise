# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/tnef/tnef-1.4.1.ebuild,v 1.1 2006/07/21 21:42:49 tsunam Exp $

DESCRIPTION="Decodes MS-TNEF MIME attachments"
SRC_URI="mirror://sourceforge/tnef/${P}.tar.gz"
HOMEPAGE="http://world.std.com/~damned/software.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_install() {
	emake DESTDIR=${D} install || die emake install failed
	rm -rf ${D}/usr/man
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
	doman doc/tnef.1
}
