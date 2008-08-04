# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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
	media-libs/jpeg
	>=gnome-extra/desktop-data-model-1.2
	>=net-misc/curl-7.13.1
	>=sys-apps/dbus-1
	x11-libs/cairo
	>=x11-libs/gtk+-2.10
	x11-libs/libXScrnSaver
	>=x11-libs/hippo-canvas-0.2.30
	x11-libs/pango
	firefox? ( !xulrunner? ( www-client/mozilla-firefox ) )
	xulrunner? ( net-libs/xulrunner )"

DEPEND=">=dev-util/pkgconfig-0.19
	>=gnome-base/gconf-2
	${RDEPEND}"

FIREDIRS="/usr/$(get_libdir)/mozilla-firefox"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# configure looks in the wrong place for xpidl
	sed -e 's:bin/xpidl:xpidl:' -i configure.ac
	epatch "${FILESDIR}/${PN}-1.1.92-libxpcom.patch"
	epatch "${FILESDIR}/${PN}-1.1.93-use-firefox.patch"
	eautoreconf
	if use firefox || use xulrunner ; then
		G2CONF="--enable-firefox"
		if use xulrunner ; then
			G2CONF="${G2CONF} --with-gecko-sdk=/usr/$(get_libdir)/xulrunner"
		else
			G2CONF="${G2CONF} --with-gecko-sdk=/usr/$(get_libdir)/mozilla-firefox"
		fi

		# use the correct libdir in the firefox-update.sh script
		sed -e "s:GET_LIBDIR:$(get_libdir):" \
			"${FILESDIR}/${PN}-1.1.58-firefox-update.sh" > "${S}/firefox-update.sh"

		# add support for (32-bit) mozilla-firefox-bin if our profile is
		# x86 or amd64 with a 32-bit userland
		if [ "${ARCH}" = "x86" -o "${ABI}" = "x86" ] ; then
			FIREDIRS="${FIREDIRS} /opt/firefox"
		fi
		sed -e "s:FIREDIRS:${FIREDIRS}:" -i "${S}/firefox-update.sh"
	else
		G2CONF="--disable-firefox"
	fi
}

src_install() {
	gnome2_src_install

	# this replaces the broken pkg_prerm logic we had before, which removed the
	# firefox extensions on every upgrade.
	if use firefox || use xulrunner ; then
		einfo "Installing firefox extension."
		for d in ${FIREDIRS} ; do
			if [ -e "$d/firefox-bin" -a -d "$d/extensions" ] ; then
				dosym "/usr/$(get_libdir)/mugshot/firefox" "${d}/extensions/firefox@mugshot.org"
			fi
		done
	fi
}

pkg_postinst () {
	gnome2_pkg_postinst

	if use firefox || use xulrunner ; then
		# pkg_prerm logic was broken in older ebuilds
		elog
		elog "If you are upgrading from <net-misc/mugshot-1.1.58 please run"
		elog " /usr/share/firefox-update.sh install"
		elog "to properly install the firefox extension."
		elog
		elog "Please restart firefox in order to use the mugshot extension."
	fi
}
