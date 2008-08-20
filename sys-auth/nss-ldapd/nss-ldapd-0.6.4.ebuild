# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib autotools

DESCRIPTION="NSS module for name lookups using LDAP"
HOMEPAGE="http://ch.tudelft.nl/~arthur/nss-ldapd/"
SRC_URI="http://ch.tudelft.nl/~arthur/nss-ldapd/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sasl kerberos"

DEPEND="net-nds/openldap
	sasl? ( dev-libs/cyrus-sasl )
	kerberos? ( virtual/krb5 )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix configure.ac to make sasl and kerberos support configurable
	epatch "${FILESDIR}/${PN}-0.6.4-configure-fixes.patch"
	eautoreconf
}

src_compile() {
	# nss libraries go in /lib (as opposed to /usr/lib)
	econf \
		$(use_enable sasl) \
		$(use_enable kerberos) \
		--libdir=/$(get_libdir)

	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	insinto /etc
	doins nss-ldapd.conf

	insinto /usr/share/nss-ldapd
	doins nss-ldapd.conf

	newinitd "${FILESDIR}"/nslcd.rc nslcd

	dodoc NEWS ChangeLog AUTHORS README || die "error installing documentation"

	# Make directory for pid file and socket file
	keepdir /var/run/nslcd
}

pkg_postinst() {
	echo
	elog "In order to use nss-ldapd, nslcd needs to be running.  You can start"
	elog "it like this:"
	elog "	# /etc/init.d/nslcd start"
	elog
	elog "You can add it to the default runlevel like so:"
	elog "	# rc-update add nslcd default"
	echo
}
