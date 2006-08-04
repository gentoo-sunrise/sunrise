# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/azureus-bin/azureus-bin-2.4.0.2.ebuild,v 1.1 2006/03/18 10:10:23 eradicator Exp $

inherit eutils java-pkg

DESCRIPTION="Azureus - Java BitTorrent Client"
HOMEPAGE="http://azureus.sourceforge.net/"

MY_PN=${PN/-bin/}
MY_PV="${PV}"
MY_DT=20040224

S=${WORKDIR}/${MY_PN}
SRC_URI="mirror://gentoo/seda-${MY_DT}.zip
	x86? ( mirror://sourceforge/${MY_PN}/Azureus_${MY_PV}_linux.tar.bz2 )
	amd64? ( mirror://sourceforge/${MY_PN}/Azureus_${MY_PV}_linux-x86_64.tar.bz2 )
	ppc? ( mirror://sourceforge/${MY_PN}/Azureus_${MY_PV}_linux-PPC.tar.bz2 )"

LICENSE="GPL-2 BSD"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~x86"
IUSE="kde"

DEPEND="virtual/libc
	app-arch/unzip
	!net-p2p/azureus"

RDEPEND="${DEPEND}
	kde? ( dev-java/systray4j )
	net-libs/linc
	=x11-libs/gtk+-2*
	>=virtual/jre-1.4"

# Where to install the package
PROGRAM_DIR="/usr/$(get_libdir)/${MY_PN}"

src_unpack() {
	if ! use kde; then
		einfo "The kde use flag is off, so the systray support will be disabled."
		einfo "kde is required to build dev-java/systray4j."
	fi

	unpack ${A}

	cp ${FILESDIR}/${PN}-gentoo.sh ${MY_PN}/azureus || die "failed to copy wrapper"

	# Set runtime settings in the startup script
	sed -i "s:##PROGRAM_DIR##:${PROGRAM_DIR}:" ${MY_PN}/azureus

	# Unpack seda
	cd ${S}
	tar xjf ${WORKDIR}/seda-jnilibs-linux.tar.bz2
}

src_compile() {
	einfo "Binary only installation.  No compilation required."
}

src_install() {
	cd ${S}

	insinto ${PROGRAM_DIR}
	exeinto ${PROGRAM_DIR}

	java-pkg_dojar *.jar
	doexe *.so

	# keep the plugins dir bug reports from flowing in
	insinto ${PROGRAM_DIR}/plugins/azupdater
	doins plugins/azupdater/*

	dobin azureus

	insinto /usr/share/pixmaps
	doins ${FILESDIR}/azureus.png

	insinto /usr/share/applications
	doins ${FILESDIR}/azureus.desktop

	dodoc seda-README.txt
	dohtml swt-about.html
}

pkg_postinst() {
	echo
	einfo "Due to the nature of the portage system, we recommend"
	einfo "that users check portage for new versions of Azureus"
	einfo "instead of attempting to use the auto-update feature."
	einfo "You can disable the upgrade warning in"
	einfo "View->Configuration->Interface->Start"
	echo
	einfo "After running azureus for the first time, configuration"
	einfo "options will be placed in ~/.Azureus/gentoo.config"
	einfo "It is recommended that you modify this file rather than"
	einfo "the azureus startup script directly."
	echo
	einfo "As of this version, the new ui type 'console' is supported,"
	einfo "and this may be set in ~/.Azureus/gentoo.config."
	echo
	ewarn "If you are upgrading, and the menu in azurues has entries like"
	ewarn "\"!MainWindow.menu.transfers!\" then you have a stray MessageBundle.properties file,"
	ewarn "and you may safely delete ~/.Azureus/MessagesBundle.properties"
	echo
	einfo "It's recommended to use sun-java in version 1.5 or later."
	einfo "If you'll notice any problems running azureus and you've"
	einfo "got older java, try to upgrade it"
	echo
}
