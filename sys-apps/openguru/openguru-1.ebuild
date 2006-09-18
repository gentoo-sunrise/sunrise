# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic toolchain-funcs

DESCRIPTION="openGuru is an utility used to read Abit uGuru sensors"
HOMEPAGE="http://forum.abit-usa.com/showpost.php?p=532726"
SRC_URI="http://hem.bredband.net/b330708/oguru/oguru.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
S=${WORKDIR}


src_compile() {
	! has_hardened && CFLAGS="${CFLAGS} -Wl,-z,now"
	$(tc-getCC) ${CFLAGS} -o ${PN} main.c openGuru.c || die "Compile failed"
}

src_install() {
	into /usr
	dobin openguru
	# segfaults if not run with root privs
	fowners root:wheel /usr/bin/openguru
	fperms 4510 /usr/bin/openguru
}

pkg_postinst() {
	elog "Now you can run ${PN} as root to read sensors values."
	ewarn "If you want non-root users to be able to use ${PN} as well,"
	ewarn "you must add them to wheel group - see man usermod."
}
