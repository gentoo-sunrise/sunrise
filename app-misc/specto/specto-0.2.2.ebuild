# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_MODNAME="spectlib"
inherit distutils

DESCRIPTION="A desktop application to watch configurable events and then trigger notifications."
HOMEPAGE="http://specto.sourceforge.net/"
SRC_URI="http://specto.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

LANGS="cs de es fr it pt_BR ro sv tr"
for i in ${LANGS} ; do
	IUSE="${IUSE} linguas_${i}"
done

DEPEND="dev-python/dbus-python
	dev-python/gnome-python
	dev-python/gnome-python-extras
	dev-python/notify-python
	>=dev-python/pygtk-2.10"

src_unpack() {
	distutils_src_unpack

	sed -i -e "s:share/doc/specto:share/doc/${PF}:" \
		"${S}"/setup.py "${S}"/spectlib/util.py

	# Replace some GNOME icons with their FreeDesktop equivalents
	# so that it works with oxygen as a theme.
	sed -i -e '/icon_theme\.load_icon/s:"error":"dialog-error":g' \
		"${S}"/spectlib/*.py
	sed -i -e '/icon_theme\.load_icon/s:"reload":"view-refresh":g' \
		"${S}"/spectlib/*.py
}

src_install() {
	distutils_src_install
	dodoc data/doc/{AUTHORS,ChangeLog}
	rm -rf "${D}"/usr/share/doc/${PN}
	for i in ${LANGS} ; do
		use linguas_${i} || rm -rf "${D}"/usr/share/locale/${i}
	done
}
