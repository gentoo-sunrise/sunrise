# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit qt3 eutils fdo-mime

DESCRIPTION="An IDE for tigcc"
HOMEPAGE="http://tigcc.ticalc.org/"
SRC_URI="mirror://sourceforge/tigcc-linux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

COMMON_DEPEND=">=x11-libs/qt-3.3:3
	>=kde-base/kdelibs-3.5.7:3.5
	dev-util/ctags
	dev-embedded/tigcc
	>=sci-libs/libticables2-0.1.3
	>=sci-libs/libticonv-0.0.1
	>=sci-libs/libtifiles2-0.0.9
	>=sci-libs/libticalcs2-0.2.4"

RDEPEND="${COMMON_DEPEND}
	!minimal? ( dev-util/ktigcc-completion-data )"

DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"
S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e 's/^qmake/${QTDIR}\/bin\/qmake/g' -i configure
}

src_install() {
	dobin ktigcc
	dodoc NEWS

	# mime-type registration for project files
	newicon "${S}"/images/ktigcc.png application-x-tigcc-project.png

	insinto /usr/share/mimelnk/application
	doins "${FILESDIR}"/x-tigcc-project.desktop

	insinto /usr/share/mime/packages
	doins "${FILESDIR}"/ktigcc.xml

	# menu entry
	# can't use make_desktop_entry here, because I need mime-type association
	newicon "${S}"/images/icon.png ${PN}.png
	domenu "${FILESDIR}"/ktigcc.desktop
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
