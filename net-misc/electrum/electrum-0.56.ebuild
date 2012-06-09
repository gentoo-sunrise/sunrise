# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.5 3.*"

inherit eutils distutils gnome2-utils

MY_P=Electrum-${PV}
DESCRIPTION="Lightweight Bitcoin client"
HOMEPAGE="http://ecdsa.org/electrum/"
SRC_URI="http://ecdsa.org/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk qt4"
REQUIRED_USE="|| ( gtk qt4 )"

LANGS="en de fr sl vi"

for X in ${LANGS}; do
	IUSE+=" linguas_${X}"
done
unset X

DEPEND=""
RDEPEND="dev-python/ecdsa
	dev-python/slowaes
	gtk? ( dev-python/pygtk:2 )
	qt4? ( dev-python/PyQt4 )"

S=${WORKDIR}/${MY_P}

DOCS="RELEASE-NOTES"

src_prepare() {
	# Prevent icon from being installed in the wrong location:
	sed -i '/electrum\.png/ d' setup.py || die
	sed -i "s:^Icon=.*:Icon=${PN}:" "${PN}.desktop" || die

	# Fix language codes (from country codes)
	mv locale/vn locale/vi || die  # Vietnamese
	mv locale/si locale/sl || die  # Slovenian

	# Remove unused localizations:
	local lang
	for lang in $LANGS; do
		if [ $lang != en ] && use !linguas_$lang; then
			rm -r locale/$lang || die
		fi
	done

	# Get rid of unused GUI implementations:
	if use !gtk; then
		rm lib/gui.py || die
	fi
	if use !qt4; then
		rm lib/gui_qt.py || die
		sed -i 's/default="qt"/default="gtk"/' electrum || die
	fi

	distutils_src_prepare
}

src_install() {
	doicon -s 64 ${PN}.png
	distutils_src_install
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	distutils_pkg_postinst
}

pkg_postrm() {
	gnome2_icon_cache_update
	distutils_pkg_postrm
}
