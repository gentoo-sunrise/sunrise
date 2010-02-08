# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
NEED_PYTHON="2.5"

inherit eutils python

DESCRIPTION="Mouse gesture recognition for netwm-compliant WMs"
HOMEPAGE="http://gestikk.reichbier.de/"
SRC_URI="http://gestikk.reichbier.de/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libnotify"

RDEPEND="dev-python/kiwi
	>=dev-python/pyparsing-1.4.7
	dev-python/python-virtkey
	libnotify? ( dev-python/notify-python )"

src_prepare() {
	# By default, libnotify is required even if it's not used.
	# This removes whole libnotify-dependant code if we don't want it.
	use libnotify || epatch "${FILESDIR}"/${P}-remove-libnotify.diff

	# Fix icon location.
	epatch "${FILESDIR}"/${PN}-icon-path.diff

	# Single .po leftover.
	rm locale/de/LC_MESSAGES/gestikk.po
}

src_install() {
	# Layout based on .deb.

	newbin gestikk.py gestikk || die "dobin failed."
	insinto "$(python_get_sitedir)"/gestikk
	doins gestikk/*.py || die "doins failed."
	insinto /usr/share/gestikk
	doins gestikk.glade || die "doins failed."
	insinto /usr/share
	doins -r locale || die "doins failed."

	# Package provides both .xpm & .png, but internally refers to .xpm only.
	doicon media/gestikk.xpm || die "doicon failed."

	# Package doesn't supply any .desktop files, so let's make some.
	make_desktop_entry gestikk '' '' 'Utility;GTK;TrayIcon' \
		|| die "make_desktop_entry failed."
	make_desktop_entry 'gestikk -c' 'gestikk configuration' gestikk 'Utility;GTK' \
		|| die "make_desktop_entry failed."

	dodoc README TRANSLATORS || die "dodoc failed."
}

pkg_postinst() {
	python_mod_optimize "$(python_get_sitedir)"/gestikk
}

pkg_postrm() {
	python_mod_cleanup "$(python_get_sitedir)"/gestikk
}
