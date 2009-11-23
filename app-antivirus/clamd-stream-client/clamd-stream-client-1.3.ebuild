# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Small client to ask a remote clamav antivirus server if a file contains a virus"
HOMEPAGE="http://clamd-stream-cl.sourceforge.net/"
SRC_URI="mirror://sourceforge/clamd-stream-cl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install()	{
	dobin ${PN} || die "dobin failed"
	dodoc README || die "dodoc failed"
}
