# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit pam toolchain-funcs

DESCRIPTION="Provides auto blacklisting of hosts and users responsible for repeated failed authentication attempts"
HOMEPAGE="http://www.hexten.net/pam_abl/"
SRC_URI="mirror://sourceforge/${PN/_/-}/${P}.tar.gz"
RESTRICT=""

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=sys-libs/pam-0.78-r2
	>=sys-libs/db-4.2.52_p2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix hardcoded values in Makefile
	sed -i -e "s:-Wall -fPIC:${CFLAGS} -Wall -fPIC:" \
	    -e "s:/lib/security:$(getpam_mod_dir):" \
	    -e "s:cc:$(tc-getCC):" \
	    -e "s:ld -:$(tc-getLD) -:" Makefile || die "sed failed in Makefile"
	sed -i -e "s:-Wall:${CFLAGS} -Wall:" \
	    -e "s:cc:$(tc-getCC):" tools/Makefile || die "sed failed in tools/Makefile"

	# comment out default configuration
	sed -i -e "s:host:#host:" \
	    -e "s:user:#user:" conf/pam_abl.conf || die "sed failed in conf/pam_abl.conf"
}

src_install() {
	dopammod pam_abl.so
	dopamd "${FILESDIR}/system-auth"
	insinto /etc/security
	doins conf/pam_abl.conf
	dobin tools/pam_abl
	dodir /var/lib/abl
	dohtml doc/*.html doc/*.css
}

pkg_postinst() {
	elog "See /usr/share/doc/${PF}/html/index.html for configuration info"
	elog "and set up /etc/security/pam_abl.conf as needed."
}
