# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Unbound is a validating, recursive and caching DNS resolver."
HOMEPAGE="http://unbound.net"
SRC_URI="http://unbound.net/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug libevent static threads"

DEPEND="dev-libs/openssl
	>=net-libs/ldns-1.4.0
	libevent? ( dev-libs/libevent )"

pkg_setup() {
	enewgroup unbound
	enewuser unbound -1 -1 -1 unbound
}

src_compile() {
	econf \
		--with-conf-file=/etc/unbound/unbound.conf \
		--with-pidfile=/var/run/unbound.pid \
		--with-run-dir=/etc/unbound \
		--with-username=unbound \
		$(use_enable debug) \
		$(use_enable debug lock-checks) \
		$(use_enable debug alloc-checks) \
		$(use_enable static static-exe) \
		$(use_with libevent) \
		$(use_with threads pthreads)

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}/unbound.initd" unbound || die "newinitd failed"
	newconfd "${FILESDIR}/unbound.confd" unbound || die "newconfd failed"

	dodoc doc/README doc/CREDITS doc/TODO doc/Changelog doc/FEATURES || die "dodoc failed"
	dodoc "${FILESDIR}/chroot_howto.txt" || die "dodoc failed"

	# adapt config file to disable the chroot
	sed -i '/^\t# chroot:/a\\tchroot: ""' "${D}/etc/unbound/unbound.conf" || die "sed failed"
}

pkg_postinst() {
	elog "The gentoo configuration does not enable a chroot environment,"
	elog "this differs from the default upstream configuration."
	elog "To use a chroot enviroment which is recommended, please read"
	elog "the chroot_howto.txt in /usr/share/doc/${PF}"
}
