# Copyright 2006-2006 Mikael Lammentausta
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Shell scripts to manage POSIX accounts in an LDAP."
HOMEPAGE="http://contribs.martymac.com/"
SRC_URI="http://contribs.martymac.com/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND="net-nds/openldap
	 dev-libs/uulib"

RUNTIMEDIR="/var/run/${PN}"
RUNTIMEFILE="runtime"
ETCDIR="/etc/${PN}"
ETCFILE="ldapscripts.conf"

src_unpack() {

	unpack ${A}

	# patch with fixes to problematic chown $HOME, add support to gecos
	# specification. patches are sent upstream.
	cd ${S}/bin
	epatch "${FILESDIR}/ldapadduser.patch"
	cd ${S}/etc
	epatch "${FILESDIR}/ldapscripts.conf.patch"

	# Prepare sources, as the install script would do it
	cd ${S}
	sed -i.orig -e "s|^_RUNTIMEFILE=.*|_RUNTIMEFILE=\"${RUNTIMEDIR}/${RUNTIMEFILE}\"|g" bin/*
	sed -i.orig -e "s|^_CONFIGFILE=.*|_CONFIGFILE=\"${ETCDIR}/${ETCFILE}\"|g" etc/*

}

src_install() {

	dobin bin/*
	doman man/man1/*

	dodir ${RUNTIMEDIR}
	insinto ${RUNTIMEDIR}
	doins etc/${RUNTIMEFILE}

	dodir ${ETCDIR}
	insinto ${ETCDIR}
	doins etc/${ETCFILE}

	dodoc CHANGELOG README TODO VERSION

}
