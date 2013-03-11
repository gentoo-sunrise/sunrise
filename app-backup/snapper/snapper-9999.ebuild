# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils git-2

DESCRIPTION="Command-line program for btrfs and ext4 snapshot management"
HOMEPAGE="http://snapper.io/"
EGIT_REPO_URI="git://github.com/openSUSE/snapper.git"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="dev-libs/boost
	dev-libs/libxml2
	sys-apps/dbus
	sys-libs/zlib
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	# No configure file provided at the moment
	eautoreconf
}

src_configure() {
	# No YaST in Gentoo
	econf --disable-zypp --with-conf="/etc/conf.d"
}

src_install() {
	emake DESTDIR="${D}" install
	nonfatal dodoc AUTHORS LIBVERSION VERSION package/snapper.changes
	# Exising configuration file required to function
	newconfd data/sysconfig.snapper snapper
	prune_libtool_files
}

pkg_postinst() {
	elog "In order to use Snapper, you need to set up at least one config"
	elog "manually, or else the tool will get confused. Typically you should"
	elog "create a '/.snapshots' directory, then copy the file"
	elog "'/etc/snapper/config-templates/default' into '/etc/snapper/configs/',"
	elog "rename the file to 'root', and add its name into '/etc/conf.d/snapper'."
	elog "That will instruct Snapper to snapshot the root of the filesystem by"
	elog "default. For more information, see the snapper(8) manual page."
}
