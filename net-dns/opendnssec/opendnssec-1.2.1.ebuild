# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit confutils eutils multilib

DESCRIPTION="An open-source turn-key solution for DNSSEC"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://www.opendnssec.org/files/source/${P}.tar.gz"
LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+auditor debug eppclient external-hsm mysql opensc +signer softhsm sqlite"
# Test suite needs a preconfigured sqlite/mysql database, and a cunit with curses support
RESTRICT="test"

DEPEND="dev-libs/libxml2
	>=net-libs/ldns-1.6.9
	auditor? ( dev-lang/ruby[ssl] >=dev-ruby/dnsruby-1.52 )
	eppclient? ( net-misc/curl dev-db/sqlite:3 )
	mysql? ( >=virtual/mysql-5.0 )
	opensc? ( dev-libs/opensc )
	softhsm? ( dev-libs/softhsm )
	sqlite? ( dev-db/sqlite:3 )"
RDEPEND="${DEPEND}"

PKCS11_LIB=""
PKCS11_PATH=""

check_pkcs11_setup() {
	# PKCS#11 HSM's are often only available with proprietary drivers not available in portage.
	# The following setup routine allows to build against these drivers.

	if use softhsm; then
		PKCS11_LIB=softhsm
		PKCS11_PATH=/usr/$(get_libdir)/libsofthsm.so
		einfo "Building with SoftHSM PKCS#11 library support."

	elif use opensc; then
		PKCS11_LIB=opensc
		PKCS11_PATH=/usr/$(get_libdir)/opensc-pkcs11.so
		einfo "Building with OpenSC PKCS#11 library support."

	elif use external-hsm; then
		# Use an arbitrary non-portage PKCS#11 library, set by an environment variable
		if [ -n "$PKCS11_SOFTHSM" ]; then
			# This is for testing, since it's the only actual library I have. Set USE=softhsm instead.
			PKCS11_LIB=softhsm
			PKCS11_PATH="$PKCS11_SOFTHSM"

		elif [ -n "$PKCS11_SCA6000" ]; then
			PKCS11_LIB=sca6000
			PKCS11_PATH="$PKCS11_SCA6000"

		elif [ -n "$PKCS11_ETOKEN" ]; then
			PKCS11_LIB=etoken
			PKCS11_PATH="$PKCS11_ETOKEN"

		elif [ -n "$PKCS11_NCIPHER" ]; then
			PKCS11_LIB=ncipher
			PKCS11_PATH="$PKCS11_NCIPHER"

		elif [ -n "$PKCS11_AEPKEYPER" ]; then
			PKCS11_LIB=aepkeyper
			PKCS11_PATH="$PKCS11_AEPKEYPER"

		else
			ewarn "You enabled USE flag 'external-hsm' but did not specify a path to a PKCS#11"
			ewarn "library. To set a path, set one of the following environment variables:"
			ewarn "  for Sun Crypto Accelerator 6000, set: PKCS11_SCA6000=<path>"
			ewarn "  for Aladdin eToken, set: PKCS11_ETOKEN=<path>"
			ewarn "  for Thales/nCipher netHSM, set: PKCS11_NCIPHER=<path>"
			ewarn "  for AEP Keyper, set: PKCS11_AEPKEYPER=<path>"
			ewarn "Example:"
			ewarn "  PKCS11_ETOKEN=\"/opt/etoken/lib/libeTPkcs11.so\" emerge -pv opendnssec"
			ewarn "Note: For SoftHSM or OpenSC support, just enable the appropriate USE flag."
			die "USE flag 'external-hsm' set but no PKCS#11 library path specified."
		fi

		elog "Building with external PKCS#11 library support ($PKCS11_LIB): ${PKCS11_PATH}"
	else
		# Should never happen because of 'confutils_require_one softhsm opensc external-hsm'
		die "No PKCS#11 library specified through USE flags."
	fi
}

pkg_setup() {
	use eppclient && ewarn "Use of eppclient is still experimental"
	use mysql && ewarn "Use of mysql is still experimental"

	confutils_require_one mysql sqlite
	confutils_require_one softhsm opensc external-hsm

	check_pkcs11_setup

	enewgroup opendnssec
	enewuser opendnssec -1 -1 -1 opendnssec
}

src_prepare() {
	# Patch removes xml comments from config file to enable privilege dropping by default
	epatch "${FILESDIR}/${PN}-drop-privileges.patch"
}

src_configure() {
	# Values set by check_pkcs11_setup
	local myconf="--with-pkcs11-${PKCS11_LIB}=${PKCS11_PATH}"

	use mysql && myconf="$myconf --with-database-backend=mysql"
	use sqlite && myconf="$myconf --with-database-backend=sqlite3"

	econf $myconf \
	$(use_enable auditor) \
	$(use_enable debug timeshift) \
	$(use_enable eppclient) \
	$(use_enable signer)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}"/opendnssec.initd opendnssec || die "newinitd failed"
	dodoc KNOWN_ISSUES NEWS README || die "dodoc failed"

	# Remove subversion tags from config files to avoid useless config updates
	sed -i -e 's/<!-- \$Id:.* \$ -->//g' "${D}"etc/opendnssec/* || die "sed failed for files in /etc/opendnssec"

	# add upgrade script
	insinto /usr/share/opendnssec
	if use sqlite; then
		doins enforcer/utils/migrate_keyshare_sqlite3.pl || die "doins failed for migrate_keyshare_sqlite3.pl"
	elif mysql; then
		doins enforcer/utils/migrate_keyshare_mysql.pl || die "doins failed for migrate_keyshare_mysql.pl"
	fi

	# Set ownership of config files
	fowners root:opendnssec /etc/opendnssec/{conf,kasp,zonelist,zonefetch}.xml || die "fowners failed for files in /etc/opendnssec"
	if use eppclient; then
		fowners root:opendnssec /etc/opendnssec/eppclientd.conf || die "fowners failed for /etc/opendnssec/eppclientd.conf"
	fi

	# Set ownership of working directories
	fowners opendnssec:opendnssec /var/lib/opendnssec/{,signconf,signed,tmp} || die "fowners failed for dirs in /var/lib/opendnssec"
	fowners opendnssec:opendnssec /var/lib/run/opendnssec || die "fowners failed for /var/lib/run/opendnssec"
}

pkg_postinst() {
	elog "If you are upgrading from a pre-1.2.0 install, you'll need to update your"
	elog "key (KASP) database. Please run the following command to do so:"
	if use sqlite; then
		elog "  perl /usr/share/opendnssec/migrate_keyshare_sqlite3.pl -d /var/lib/opendnssec/kasp.db"
		elog "You'll need to emerge 'dev-perl/DBD-SQLite' if it is not installed yet."
	elif use mysql; then
		elog "  perl /usr/share/opendnssec/migrate_keyshare_mysql.pl -d <database> -u <username> -p <password>"
		elog "You'll need to emerge 'dev-perl/DBD-mysql' if it is not installed yet."
	fi
	elog ""

	if use softhsm; then
		elog "Please make sure that you create your softhsm database in a location writeable"
		elog "by the opendnssec user. You can set its location in /etc/softhsm.conf."
		elog "Suggested configuration is:"
		elog "  echo \"0:/var/lib/opendnssec/softhsm_slot0.db\" >> /etc/softhsm.conf"
		elog "  softhsm --init-token --slot 0 --label OpenDNSSEC"
		elog "  chown opendnssec:opendnssec /var/lib/opendnssec/softhsm_slot0.db"
	fi
}
