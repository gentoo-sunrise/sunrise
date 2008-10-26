# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils

DESCRIPTION="Fast and easy to use command line email client based on Pine."
HOMEPAGE="http://www.washington.edu/alpine/
http://staff.washington.edu/chappa/alpine/"
SRC_URI="ftp://ftp.cac.washington.edu/${PN}/${P}.tar.bz2
	chappa? (
	http://dev.gentooexperimental.org/~tommy/distfiles/chappa-${P}.patch.gz )"
# When the patch is not needed anymore inform Tommy[D] so he can
# remove the patch from his home directory.

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+chappa +ipv6 kerberos ldap +nls +mime +ssl tcl +threads"

DEPEND="sys-libs/ncurses
	ssl? ( dev-libs/openssl )
	ldap? ( net-nds/openldap )
	kerberos? ( app-crypt/mit-krb5 )"
RDEPEND="${DEPEND}
	app-misc/mime-types"

src_unpack() {
	unpack ${P}.tar.bz2
	cd "${S}"
	epatch "${DISTDIR}/chappa-${P}.patch.gz"
}

src_compile() {
	econf \
		$( use_with ssl ) \
		$( use_with kerberos krb5 ) \
		$( use_with ldap ) \
		$( use_with mime smime ) \
		$( use_with ipv6 ) \
		$( use_with tcl ) \
		$( use_with threads pthread )

	emake || die "Build failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc README NOTICE || die "dodoc failed."
}

pkg_postinst() {
	elog "For additional functionality you may want to"
	elog "install some of the programs listed below"
	elog " * aspell for spell checking"
	elog " * topal for encryption and signing"
}

