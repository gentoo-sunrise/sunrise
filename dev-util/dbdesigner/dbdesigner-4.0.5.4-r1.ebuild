# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="DBDesigner4"

DESCRIPTION="QT Database Designer for mysql"
HOMEPAGE="http://www.fabforce.net"
SRC_URI="http://downloads.mysql.com/${MY_PN}/DBDesigner${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RDEPEND="sys-libs/lib-compat
	x11-libs/kylixlibs3-borqt"
DEPEND=""

S=${WORKDIR}/${MY_PN}

LL="opt/${MY_PN}/Linuxlib"
QA_PRESTRIPPED="${LL}/libdbxoodbc.so
	${LL}/libDbxSQLite.so.2.8.5
	${LL}/sqlite.so
	${LL}/libqt.so.2.3.2
	${LL}/bplrtl.so.6.9.0
	${LL}/libmidas.so.1.0
	${LL}/libqtintf-6.9.0-qt2.3.so
	opt/${MY_PN}/DBDplugin_SimpleWebFront
	opt/${MY_PN}/DBDplugin_HTMLReport
	opt/${MY_PN}/DBDplugin_DataImporter
	opt/${MY_PN}/${MY_PN}"
QA_TEXTRELS="${LL}/libsqlora.so.1.0
	${LL}/libmidas.so.1.0
	${LL}/libpng.so.2.1.0.12"

src_install() {
	local optdir=/opt/${MY_PN}

	insinto "${optdir}"
	doins -r "${S}"/* || die "doins failed"

	ebegin "Fixing permissions of DBDesigner4 executable"
	fperms 111 "${optdir}/${MY_PN}"
	eend

	ebegin "Fixing permissions of startdbd executable"
	fperms 111 "${optdir}"/startdbd
	eend

	cd "${D}/${INSTALLDIR}"/Linuxlib
	einfo "Creating symlinks"
	ln -sfn "${D}"/opt/kylix3/libborqt-6.9-qt2.3.so libqt.so.2
	ln -sfn bplrtl.so.6.9.0 bplrtl.so.6.9
	ln -sfn dbxres.en.1.0 dbxres.en.1
	ln -sfn libmidas.so.1.0 libmidas.so.1
	ln -sfn libmysqlclient.so.10.0.0 libmysqlclient.so
	ln -sfn libqtintf-6.9.0-qt2.3.so libqtintf-6.9-qt2.3.so
	ln -sfn libsqlmy23.so.1.0 libsqlmy23.so
	ln -sfn libsqlmy23.so libsqlmy.so
	ln -sfn libsqlora.so.1.0 libsqlora.so
	ln -sfn libDbxSQLite.so.2.8.5 libDbxSQLite.so
	ln -sfn liblcms.so.1.0.9 liblcms.so
	ln -sfn libpng.so.2.1.0.12 libpng.so.2
	ln -sfn libstdc++.so.5.0.0 libstdc++.so.5
	cd "${S}"

	dobin startdbd || die "dobin failed"

	ebegin "Creating Icons"
	newicon Gfx/Icon48.xpm Icon48.xpm
	make_desktop_entry startdbd ${MY_PN} Icon48.xpm "Applications;Development"
	eend
}

pkg_postinst() {
	einfo
	einfo "DBDesigner4 is now installed. Use startdbd command to run it"
	einfo
}
