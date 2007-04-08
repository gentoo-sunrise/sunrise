# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit qt3 eutils fdo-mime

DESCRIPTION="An IDE for tigcc"
HOMEPAGE="http://tigcc.ticalc.org/"
SRC_URI="mirror://sourceforge/tigcc-linux/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="no-completion-data"

DEPEND="$(qt_min_version 3.3)
	>=kde-base/kdelibs-3.5.2
	dev-util/ctags
	dev-util/pkgconfig
	dev-embedded/tigcc
	>=sci-libs/libticables2-20060723
	>=sci-libs/libticonv-20060723-r1
	>=sci-libs/libtifiles2-20060723
	>=sci-libs/libticalcs2-20060723"

RDEPEND="${DEPEND}
	!no-completion-data? ( dev-util/ktigcc-completion-data )"

S=${WORKDIR}/${PN}

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

	# ktigcc wants to call ctags and not exuberant-ctags
	dosym exuberant-ctags /usr/bin/ctags
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
