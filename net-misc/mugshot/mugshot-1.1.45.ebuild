# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"
GCONF_DEBUG="no"
SCROLLKEEPER_UPDATE="no"

inherit autotools eutils gnome2 multilib

DESCRIPTION="Companion software for mugshot.org"
HOMEPAGE="http://www.mugshot.org/"
SRC_URI="http://download.mugshot.org/client/sources/linux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="firefox xulrunner"

RDEPEND=">=dev-libs/glib-2.6
	>=dev-libs/dbus-glib-0.71
	>=dev-libs/libpcre-6.3
	media-libs/jpeg
	>=gnome-base/gnome-desktop-2.10
	>=gnome-base/gnome-vfs-2
	>=net-libs/loudmouth-1
	>=net-misc/curl-7.13.1
	x11-libs/cairo
	>=x11-libs/gtk+-2.6
	x11-libs/libXScrnSaver
	x11-libs/pango
	firefox? ( !xulrunner? (
		>=www-client/mozilla-firefox-1.5 <www-client/mozilla-firefox-2.0.1 ) )
	xulrunner? ( net-libs/xulrunner )"

DEPEND=">=gnome-base/gconf-2
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# configure looks in the wrong place for xpidl
	sed -e 's:bin/xpidl:xpidl:' -i configure.ac
	epatch "${FILESDIR}/${PN}-1.1.22-as-needed.patch"
	epatch "${FILESDIR}/${PN}-1.1.42-libxpcom.patch"
	epatch "${FILESDIR}/${PN}-1.1.32-use-firefox.patch"
	eautoreconf
	if use firefox || use xulrunner ; then
		G2CONF="--enable-firefox"
		if use xulrunner ; then
			G2CONF="${G2CONF} --with-gecko-sdk=/usr/$(get_libdir)/xulrunner"
		else
			G2CONF="${G2CONF} --with-gecko-sdk=/usr/$(get_libdir)/mozilla-firefox"
		fi
		sed -e "s:GET_LIBDIR:$(get_libdir):" \
			"${FILESDIR}/${PN}-1.1.40-firefox-update.sh" > "${S}/firefox-update.sh"
		# support mozilla-firefox-bin if we are compiling for x86
		if [ "${ARCH}" = "x86" -o "${ABI}" = "x86" ] ; then
			sed -e 's:{firedir}:{firedir} /opt/firefox:' -i "${S}/firefox-update.sh"
		fi
	else
		G2CONF="--disable-firefox"
	fi
}

pkg_postinst () {
	gnome2_pkg_postinst

	# install firefox extension
	if use firefox || use xulrunner ; then
		einfo "Installing firefox extension. "
		einfo "Please restart firefox in order to use the mugshot extension."
		"${S}/firefox-update.sh" install
	fi
}

pkg_prerm () {
	# remove firefox extension
	if [ -x /usr/share/mugshot/firefox-update.sh ] ; then
		einfo "Removed the mugshot firefox extension."
		/usr/share/mugshot/firefox-update.sh remove
	fi
}
