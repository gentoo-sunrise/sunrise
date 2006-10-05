# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils mozilla-launcher multilib

DESCRIPTION="Mozilla Application Suite - web browser, email, HTML editor, IRC"
SRC_URI="http://ftp.mozilla.org/pub/mozilla.org/seamonkey/releases/${PV}/seamonkey-${PV}.en-US.linux-i686.tar.gz"
HOMEPAGE="http://www.mozilla.org/projects/seamonkey"
RESTRICT="nostrip"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="MPL-1.1 NPL-1.1"
IUSE=""

DEPEND="app-arch/unzip
	!www-client/mozilla"
RDEPEND="x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXmu
	x86? (
		>=sys-libs/lib-compat-1.0-r2
		>=x11-libs/gtk+-2.2
	)
	amd64? (
		>=app-emulation/emul-linux-x86-baselibs-1.0
		>=app-emulation/emul-linux-x86-gtklibs-1.0
	)
	>=www-client/mozilla-launcher-1.41
	=virtual/libstdc++-3.3
	virtual/libc"

S=${WORKDIR}/seamonkey

pkg_setup() {
	# This is a binary x86 package => ABI=x86
	# Please keep this in future versions
	# Danny van Dyk <kugelfang@gentoo.org> 2005/03/26
	has_multilib_profile && ABI="x86"
}

src_install() {
	declare MOZILLA_FIVE_HOME=/opt/seamonkey

	# Install seamonkey in /opt
	dodir ${MOZILLA_FIVE_HOME%/*}
	mv "${S}" "${D}${MOZILLA_FIVE_HOME}"

	# Create /usr/bin/seamonkey-bin
	install_mozilla_launcher_stub seamonkey-bin ${MOZILLA_FIVE_HOME}

	# Install icon and .desktop for menu entry
	insinto /usr/share/pixmaps
	doins "${FILESDIR}/icon/seamonkey-bin-icon.png"
	insinto /usr/share/applications
	doins "${FILESDIR}/icon/seamonkey-bin.desktop"

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}/10seamonkey-bin"
}

pkg_preinst() {
	declare MOZILLA_FIVE_HOME=/opt/seamonkey

	# Remove entire installed instance to prevent all kinds of
	# problems... see bug 44772 for example
	rm -rf "${ROOT}${MOZILLA_FIVE_HOME}"
}

pkg_postinst() {
	if use amd64; then
		echo
		einfo "NB: You just installed a 32-bit seamonkeyx"
	fi

	update_mozilla_launcher_symlinks
}

pkg_postrm() {
	update_mozilla_launcher_symlinks
}
