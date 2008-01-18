# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python multilib

MY_PN=${PN/deskbar-handlers-/}

DESCRIPTION="Unit conversion handler for the GNOME Deskbar"
HOMEPAGE="http://www.kryogenix.org/days/2006/09/06/converter-deskbar"
SRC_URI="http://svn.kryogenix.org/svn/deskbar-plugins/tags/${PV}/${MY_PN}.py"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.3
	>=x11-libs/gtk+-2.6
	>=dev-python/pygtk-2.6
	>=gnome-extra/deskbar-applet-2.14.2"
RDEPEND="${DEPEND}
	sci-calculators/units"

src_unpack() { :; }

src_install() {
	insinto /usr/$(get_libdir)/deskbar-applet/handlers
	doins "${DISTDIR}/${MY_PN}.py"
}

pkg_postinst() {
	python_mod_compile /usr/$(get_libdir)/deskbar-applet/handlers/${MY_PN}.py
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/deskbar-applet/handlers
}
