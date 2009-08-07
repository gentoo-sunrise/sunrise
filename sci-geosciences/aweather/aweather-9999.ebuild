# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools gnome2 subversion

DESCRIPTION="A weather monitoring program"
HOMEPAGE="http://lug.rose-hulman.edu/wiki/AWeather"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=">=net-libs/libsoup-2.26
	>=x11-libs/gtk+-2.16
	x11-libs/gtkglext
	sci-libs/rsl"

# gtk-doc-am needed to eautoreconf
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	doc? ( dev-util/gtk-doc )"

DOCS="ChangeLog README TODO"

# Fix for gtk-doc bug
MAKEOPTS="${MAKEOPTS} -j1"

ESVN_REPO_URI="https://lug.rose-hulman.edu/svn/proj-aweather/trunk"
# Tell SVN to accept the self-signed certificate from the server
ESVN_OPTIONS="--non-interactive --trust-server-cert"
ESVN_BOOTSTRAP="gtkdocize && eautoreconf"
