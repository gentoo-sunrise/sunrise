# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

# The globus-build tools do not require java to be installed, BUT
# configure still expects it...
inherit eutils

MY_P="gt${PV}-all-source-installer"

DESCRIPTION="The Globus Toolkit Build Tools"
HOMEPAGE="http://www.globus.org/toolkit/"

SRC_URI="http://www-unix.globus.org/ftppub/gt${PV:0:1}/${PV}/installers/src/${MY_P}.tar.bz2"

LICENSE="GTPL"

SLOT="4"
KEYWORDS="~x86"

IUSE=""

RDEPEND="dev-lang/perl"

DEPEND=${RDEPEND}

S="${WORKDIR}/${MY_P}"

GLOBUS="/opt/globus${PV:0:1}"

pkg_setup() {
	enewgroup globus
	enewuser  globus -1 -1 /var/globus globus
}

src_prepare() {
	mkdir "${S}"/build || die "making build directory failed"

	sed -e "s|%%GLOBUS%%|${GLOBUS}|" \
		"${FILESDIR}"/21globus-build > "${T}"/21globus-build \
			|| die "sed envfile failed"
}

src_configure() {
	econf --prefix="${S}/build/${GLOBUS}" \
		  --with-gptlocation="${S}/build/${GLOBUS}"
}

src_compile() {
	emake gpt || die "compile failed"
}

src_install() {
	einfo "Hand installing..."
	# The supplied Makefile install violates standard practices.  The
	# following simulates a "make DESTDIR=${D}" and moves the built
	# programs/files into ${D}
	mv -f "${S}"/build/* "${D}/" || die "mv failed"

	doenvd "${T}"/21globus-build || die "install env.d/globus-build died"

	einfo "Updating ownership and permissions..."
	fowners -R globus:globus * || die "fowners failed"
}

pkg_postrm() {
	if ! [[ -e /opt/globus4/sbin/gpt-build ]] && ! has_version sys-cluster/globus ; then
		ewarn "Globus builds and installs files into ${GLOBUS}"
		ewarn "after package installation.  After uninstalling"
		ewarn "you may want to manually remove all or part of the Globus"
		ewarn "installation directory ${GLOBUS}."
	fi
}
