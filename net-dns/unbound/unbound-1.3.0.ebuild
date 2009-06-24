# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils

DESCRIPTION="A validating, recursive and caching DNS resolver"
HOMEPAGE="http://unbound.net"
SRC_URI="http://unbound.net/downloads/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+chroot debug libevent python static threads"

DEPEND="dev-libs/openssl
	>=net-libs/ldns-1.5.1
	libevent? ( dev-libs/libevent )"
RDEPEND=${DEPEND}

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
		$(use_with threads pthreads) \
		$(use_with python pyunbound) \
		$(use_with python pythonmodule)

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}/unbound.initd" unbound || die "newinitd failed"
	newconfd "${FILESDIR}/unbound.confd" unbound || die "newconfd failed"

	dodoc doc/{README,CREDITS,TODO,Changelog,FEATURES} || die "dodoc failed"

	insinto /usr/share/${PN}
	insopts -m755
	doins contrib/{update-anchor.sh,update-itar.sh} || die "doins failed"

	# enable remote control for our rc script
	sed -i 's:^\t# control-enable\: no:\tcontrol-enable\: yes:g' "${D}/etc/unbound/unbound.conf" || die "sed failed"

	# disable chroot when requested
	if ! use chroot; then
		sed -i 's:^\t# chroot\: "/etc/unbound":\tchroot\: "":g' "${D}/etc/unbound/unbound.conf" || die "sed failed"
	fi
}

pkg_postinst() {
	local key_dir="${ROOT}etc/unbound"

	# unbound-control-setup tests for *.key existance, so copy that behaviour 
	if ! test -f ${key_dir}/unbound_server.key && ! test -f ${key_dir}/unbound_control.key; then
		ewarn "With unbound-1.3.0, we use a new initd script based on unbound-contol."
		ewarn "The initd script needs SSL keys. To generate these, please run the"
		ewarn "following command before (re)starting Unbound:"
		ewarn "emerge --config =${PF}"
	fi
}


pkg_config() {
	local key_dir="${ROOT}etc/unbound"
	local key_files="unbound_control.key unbound_control.pem unbound_server.key unbound_server.pem"

	ebegin "Generating SSL keys for unbound-control"
	/usr/sbin/unbound-control-setup -d ${key_dir}
	eend $?

	ebegin "Adjusting file permissions"
	local username=`/usr/sbin/unbound-checkconf -o username`
	cd ${key_dir}
	chown ${username} ${key_files}
	eend $?
}
