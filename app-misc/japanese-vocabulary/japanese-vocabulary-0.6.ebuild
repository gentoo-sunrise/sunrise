# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit eutils qt4 toolchain-funcs

KEYWORDS="~x86"

MY_PN=JapaneseVocabulary

DESCRIPTION="A simple vocabulary program for studying Japanese."
HOMEPAGE="http://code.google.com/p/japanese-vocabulary/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_PN}-${PV}-src.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=x11-libs/qt-4.2:4"
RDEPEND="${DEPEND}"

QT4_BUILT_WITH_USE_CHECK="sqlite3"
S=${WORKDIR}/${PN}

src_compile() {
	eqmake4 ${MY_PN}.pro
	emake || die "emake failed"
}

src_install() {
	dobin ${MY_PN}
	keepdir /usr/share/${PN}
}

pkg_postinst() {
	elog "To fetch an up-to-date vocabulary file, run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
}

pkg_config() {
	cd "${ROOT}usr/share/${PN}"
	wget "http://japanese-vocabulary.googlecode.com/files/jlpt.vocab"
	einfo "The vocabulary database is in:"
	einfo "  /usr/share/${PN}"
}

pkg_postrm() {
	# do not leave orphaned cruft behind
	if ! has_version ${CATEGORY}/${PN} ; then
		[[ -d ${ROOT}/usr/share/${PN} ]] && rm -rf "${ROOT}"/usr/share/${PN}
	fi
}
