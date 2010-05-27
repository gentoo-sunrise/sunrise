# Copyright 1999-2010 Gentoo Foundation
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
IUSE="+auditor debug eppclient external-hsm mysql opensc softhsm sqlite"
# Test suite needs a preconfigured sqlite/mysql database
RESTRICT="test"

DEPEND=">=net-libs/ldns-1.6.4
	dev-libs/libxml2
	dev-python/4suite
	auditor? ( dev-lang/ruby[ssl] dev-ruby/dnsruby )
	eppclient? ( net-misc/curl )
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
			# This is for testing, since it's the only actual library I have, set USE=softhsm instead.
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

		elog "Building with external PKCS#11 library support ($PKCS11_LIB): $PKCS11_PATH ."
	else
		# Should never happen because of 'confutils_require_one softhsm opensc external-hsm'
		die "No PKCS#11 library specified through USE flags."
	fi
}

pkg_setup() {
	if use eppclient; then
		ewarn "Use of Eppclient is still considered experimental upstream."
	fi

	confutils_require_one mysql sqlite
	confutils_require_one softhsm opensc external-hsm

	check_pkcs11_setup

	enewgroup opendnssec
	enewuser opendnssec -1 -1 -1 opendnssec
}

src_prepare() {
	# Patch removes xml comments from config file to enable privilege dropping by default
	epatch "${FILESDIR}/${P}-drop-privileges.patch"
}

src_configure() {
	# Values set by check_pkcs11_setup
	local myconf="--with-pkcs11-${PKCS11_LIB}=${PKCS11_PATH}"

	use mysql && myconf="$myconf --with-database-backend=mysql"
	use sqlite && myconf="$myconf --with-database-backend=sqlite3"

	econf $myconf \
	$(use_enable auditor) \
	$(use_enable debug timeshift) \
	$(use_enable eppclient)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	newinitd "${FILESDIR}"/opendnssec.initd opendnssec || die "newinitd failed"
	dodoc KNOWN_ISSUES NEWS README || die "dodoc failed"
	rm "${D}"/usr/share/opendnssec.spec || die "failed to remove spec file"

	# Remove subversion tags from config files to avoid useless config updates
	sed -i -e 's/<!-- \$Id:.* \$ -->//g' "${D}"/etc/opendnssec/* || die "sed failed for files in /etc/opendnssec"

	# Set ownership of config files
	fowners root:opendnssec /etc/opendnssec/{conf,kasp,zonelist,zonefetch}.xml || die "fowners failed for files in /etc/opendnssec"
	if use eppclient; then
		fowners root:opendnssec /etc/opendnssec/eppclientd.conf || die "fowners failed for /etc/opendnssec/eppclientd.conf"
	fi

	# Set ownership of working directories
	fowners opendnssec:opendnssec /var/lib/opendnssec/{,signconf,signed,tmp} || die "fowners failed for dirs in /var/lib/opendnssec"
}

pkg_postinst() {
	if use softhsm; then
		elog "Please make sure that you create your softhsm database in a location readable"
		elog "by the opendnssec user. You can set its location in ${ROOT}etc/softhsm.conf."
		elog "Suggested configuration is:"
		elog "  echo \"0:${ROOT}var/lib/opendnssec/softhsm_slot0.db\" >> ${ROOT}etc/softhsm.conf"
		elog "  softhsm --init-token --slot 0 --label OpenDNSSEC"
		elog "  chown opendnssec:opendnssec ${ROOT}var/lib/opendnssec/softhsm_slot0.db"
	fi
}
