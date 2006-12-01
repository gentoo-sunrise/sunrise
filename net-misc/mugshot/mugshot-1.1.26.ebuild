# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils gnome2 multilib

DESCRIPTION="Program to facilitate social networking"
HOMEPAGE="http://www.mugshot.org"
SRC_URI="http://download.mugshot.org/client/sources/linux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="firefox"

RDEPEND=">=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6
	>=sys-apps/dbus-0.61
	>=net-libs/loudmouth-1
	>=gnome-base/gconf-2
	>=net-misc/curl-7.13.1
	firefox? ( >=www-client/mozilla-firefox-1.5 <www-client/mozilla-firefox-2.1 )
	x11-libs/libXScrnSaver"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# configure looks in the wrong place for xpidl
	sed -e 's:bin/xpidl:xpidl:' -i configure.ac
	epatch "${FILESDIR}/${PN}-1.1.22-as-needed.patch"
	epatch "${FILESDIR}/${PN}-1.1.24-use-firefox.patch"
	eautoreconf
	use firefox && sed -e "s:GET_LIBDIR:$(get_libdir):" \
		"${FILESDIR}/${P}-firefox-update.sh" > "${S}/firefox-update.sh"
}

src_compile() {
	econf $(use_enable firefox) \
		--with-gecko-sdk=/usr/$(get_libdir)/mozilla-firefox/ || die "./configure failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}

pkg_postinst () {
	gnome2_pkg_postinst

	# install firefox extension
	if use firefox ; then
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
