# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit eutils

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}_${MY_PV}"

DESCRIPTION="Distributed key-value database management system"
HOMEPAGE="http://www.membase.org/"
SRC_URI="http://c2512712.cdn.cloudfiles.rackspacecloud.com/${MY_P}_src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-ia64 -x86"
IUSE=""

RDEPEND=">=dev-libs/libevent-2.0.7
		 >=net-misc/curl-7.21.1
		 >=dev-lang/erlang-13.2.4
		 >=sys-devel/gcc-4.3.0
		 >=dev-libs/check-0.9.4"
DEPEND="${RDEPEND}
		!>=dev-lang/erlang-14"
		# Erlang 14A no longer allows compile option nowarn_bif_clash

S="${WORKDIR}/${MY_P}_src"

src_configure() {
	dodir lib doc

	einfo "Configuring and building memcached"
	cd "${S}/memcached" || die
	econf --enable-isasl && emake || die

	einfo "Configuring bucket_engine"
	cd "${S}/bucket_engine" || die
	econf --with-memcached="${S}/memcached" || die

	einfo "Configuring ep-engine"
	cd "${S}/ep-engine" || die
	econf --with-memcached="${S}/memcached" || die

	# Some libs are depended on during the config process so build them now

	einfo "Configuring and building libmemcached"
	cd "${S}/libmemcached" || die
	econf --prefix="${S}/lib" \
		  --mandir="${S}/doc" \
		  --disable-shared \
		  --disable-dtrace \
		  --enable-static \
		  --with-memcached="${S}/memcached/memcached" || die
	emake && emake install || die

	einfo "Configuring and building libvbucket"
	cd "${S}/libvbucket" || die
	econf --prefix="${S}/lib" \
		  --mandir="${S}/doc" \
		  --disable-shared \
		  --enable-static || die
	emake && emake install || die

	einfo "Configuring and building vbucketmigrator"
	cd "${S}/vbucketmigrator" || die
	econf --prefix="${S}/lib" \
		  --mandir="${S}/doc" \
		  --without-sasl \
		  --with-isasl \
		  --with-memcached="${S}/memcached" || die
	emake || die

	einfo "Configuring and building libconflate"
	cd "${S}/libconflate" || die
	econf --prefix="${S}/lib" \
		  --mandir="${S}/doc" \
		  --disable-shared \
		  --enable-static || die
	emake && emake install || die

	einfo "Configuring moxi"
	cd "${S}/moxi" || die
	econf --prefix="${S}/lib" \
		  --mandir="${S}/doc" \
		  --with-memcached="${S}/memcached/memcached" \
		  --enable-moxi-libvbucket \
		  --enable-moxi-libmemcached \
		  CFLAGS="-I${S}/lib/include -Wno-error" \
		  LDFLAGS="-L${S}/lib/lib" || die
}

src_compile() {
	echo "Building bucket_engine"
	cd "${S}/bucket_engine" || die
	emake || die

	echo "Building ep-engine"
	cd "${S}/ep-engine" || die
	emake || die

	echo "Building moxi"
	cd "${S}/moxi" || die
	emake || die

	echo "Building ns-server"
	cd "${S}/ns_server"
	emake || die
}

src_install() {
	# Just copy the whole directory over to /opt until we split out packages
	# more efficiently (and/or respect the Makefile destinations)
	dodir opt/membase/${PV}
	cp -a "${S}"/{bucket_engine,ep-engine,libconflate,libmemcached,libvbucket,membase-cli,memcached,moxi,ns_server,vbucketmigrator} \
		  "${D}/opt/membase/${PV}" || die "Install failed!"

	# Setup keeps for the data, config, and log dirs
	dodir "etc/membase/${PV}"
	keepdir "etc/membase/${PV}"
	cp "${FILESDIR}/${PV}/config" "${D}/etc/membase/${PV}" || \
		die "Install failed!"
	dosym "etc/membase/${PV}/priv" "/etc/membase/${PV}"
	chown -R membase:daemon "${D}/etc/membase" || \
		die "Install failed!"

	dodir "var/lib/membase/${PV}/mnesia" "var/lib/membase/${PV}/data"
	keepdir "var/lib/membase/${PV}/mnesia" "var/lib/membase/${PV}/data"
	chown -R membase:daemon "${D}/var/lib/membase" || \
		die "Install failed!"

	dodir "var/log/membase/${PV}"
	keepdir "var/log/membase/${PV}"
	chown -R membase:daemon "${D}/var/log/membase/${PV}" || \
		die "Install failed!"

	# TODO: Sort through all the misc docs in the different subprojects and
	# dodoc them
	doman doc/man1/* || die
	doman doc/man3/* || die
	doman doc/man4/* || die

	# Install the initscripts
	newinitd "${FILESDIR}/${PV}/init-epmd" membase-epmd
	newinitd "${FILESDIR}/${PV}/init-server" membase-server
}

pkg_setup() {
	enewuser membase -1 -1 /var/lib/membase daemon
}
