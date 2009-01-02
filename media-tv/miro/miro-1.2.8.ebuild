# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils fdo-mime flag-o-matic multilib

EAPI="2"

MY_P="${P/m/M}"
DESCRIPTION="Open source video player"
HOMEPAGE="http://www.getmiro.com/"
SRC_URI="http://ftp.osuosl.org/pub/pculture.org/${PN}/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=" || ( >=dev-lang/python-2.5[sqlite]
		=dev-python/pysqlite-2* )
	dev-python/dbus-python
	dev-python/gconf-python
	dev-python/gnome-vfs-python
	>=dev-python/gtkmozembed-python-2.19.1-r11
	>=dev-python/pygtk-2.10
	>=net-libs/xulrunner-1.9"
DEPEND="${RDEPEND}
	>=dev-lang/python-2.5[berkdb,ssl]
	>=dev-python/pyrex-0.9.6.4
	dev-util/pkgconfig
	media-libs/xine-lib
	sys-devel/gettext"

S="${WORKDIR}/${MY_P}/platform/gtk-x11"

src_prepare() {
	cd "${WORKDIR}/${MY_P}"
	epatch "${FILESDIR}/${PN}-gcc.4.3.patch"

	# Generate MozillaBrowser.c first, for patching
	# FIXME: A proper patch to the pyrex source would be better
	cd "${S}"
	pyrexc platform/frontends/html/MozillaBrowser.pyx
	sed -i -f "${FILESDIR}"/MozillaBrowser.sed \
		platform/frontends/html/MozillaBrowser.c || \
		die "Failed to patch MozillaBrowser.c for gcc 4.3"
}

src_compile() {
	filter-ldflags -Wl,--as-needed
	distutils_src_compile
}

src_install() {
	# Make sure both READMEs get installed
	mv README README.GTK-X11
	distutils_src_install
	dodoc README.GTK-X11 ../../{CREDITS,README} || die "dodoc failed"
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	MOZSETUP="/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}/mozsetup.py"
	elog ""
	elog "To increase the font size of the main display area, add:"
	elog "user_pref(\"font.minimum-size.x-western\", 15);"
	elog ""
	elog "to the following file:"
	elog "${MOZSETUP}"
	elog ""
}
