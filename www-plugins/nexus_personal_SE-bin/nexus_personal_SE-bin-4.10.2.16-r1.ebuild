# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils multilib

DESCRIPTION="Internet banking plugin for technology by BankID company"
SRC_URI="http://install.bankid.com/InstallBankidCom/InstallFiles/LinuxPersonal.tgz -> LinuxPersonal-${PV}.tgz"
HOMEPAGE="http://bankid.com/"

KEYWORDS="~x86"
SLOT="0"
LICENSE="as-is"

# Works with these browsers
BROWSERS="epiphany firefox mozilla seamonkey"
IUSE="doc ${BROWSERS}"

S=${WORKDIR}/personal-${PV}

RDEPEND="app-crypt/mit-krb5
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	media-libs/libpng
	net-misc/curl[gnutls,kerberos]
	x11-libs/gtk+
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/pango
	virtual/jre"
DEPEND=""

RESTRICT="strip"

QA_TEXTRELS="opt/${P}/*.so"

src_install() {
	local id=/opt/${P}
	local ubin=/usr/local/bin
	local lib=$(get_abi_LIBDIR x86)

	exeinto ${id}
	doexe *.so personal.bin persadm || die "doexe failed."

	make_wrapper personal ${id}/personal.bin ${id} ${id} \
		|| die "make_wrapper failed."
	make_wrapper persadm "${id}/persadm" ${id} ${id} || die "make_wrapper failed."

	dosym /usr/bin/personal ${ubin}/personal || die "dosym failed."
	dosym /usr/bin/persadm ${ubin}/persadm || die "dosym failed."

	if use doc; then
		dohtml *.htm || die "dohtml failed."
		dodoc *.txt || die "dodoc failed."
	fi

	insinto ${id}/config
	doins Personal.cfg || die "doins failed."

	newicon nexus_logo_32x32.png ${PN}.png || die "newicon failed."
	dosym /usr/share/pixmaps/${PN}.png ${id}/icons/nexus_logo_32x32.png

	make_desktop_entry personal "Nexus Personal" ${PN} Utility

	dosym ${id}/libplugins.so /usr/${lib}/nsbrowser/plugins/libnexuspersonal.so \
		|| die "dosym failed."

	dosym /usr/${lib}/libcurl.so ${id}/libcurl-gnutls.so.4 \
		|| die "dosym failed."

	for i in ${BROWSERS}; do
		if use ${i}; then
			make_wrapper ${i}-nexus ${i} ${id} ${id}
		fi
	done
}

pkg_postinst() {
	einfo
	for i in ${BROWSERS}; do
		if use ${i}; then
			einfo "Run '${i}-nexus' for BankID plugin support."
		fi
	done
	einfo "For all other browsers:"
	einfo "\texport LD_LIBRARY_PATH=\"\${LD_LIBRARY_PATH}:${ROOT}opt/${P}\""
	einfo "for BankID plugin support, then start your browser."
	einfo
}
