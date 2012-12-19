# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils linux-info versionator

MY_PN="${PN/3g-ar/-3g}"
MY_PV="$(get_version_component_range 1-3)AR.$(get_version_component_range 4)"
MY_P="${MY_PN}_ntfsprogs-${MY_PV}"

DESCRIPTION="NTFS-3G variant supporting ACLs, junction points, compression and more"
HOMEPAGE="http://jp-andre.pagesperso-orange.fr/advanced-ntfs-3g.html"
SRC_URI="http://jp-andre.pagesperso-orange.fr/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acl crypt debug +external-fuse extras +ntfsprogs static-libs suid +udev xattr"

RDEPEND="!<sys-apps/util-linux-2.19
	!sys-fs/ntfsprogs
	crypt? (
		>=dev-libs/libgcrypt-1.2.2
		>=net-libs/gnutls-1.4.4
		)
	external-fuse? ( >=sys-fs/fuse-2.8.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-apps/attr"

S="${WORKDIR}/${MY_P}"

DOCS="AUTHORS ChangeLog CREDITS README"

pkg_setup() {
	if use external-fuse && use kernel_linux; then
		if kernel_is lt 2 6 9; then
			die "Your kernel is too old."
		fi
		CONFIG_CHECK="~FUSE_FS"
		FUSE_FS_WARNING="You need to have FUSE module built to use ntfs-3g"
		linux-info_pkg_setup
	fi
}

src_configure() {
	econf \
		--exec-prefix="${EPREFIX}/usr" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable debug) \
		--enable-ldscript \
		--disable-ldconfig \
		$(use_enable acl posix-acls) \
		$(use_enable xattr xattr-mappings) \
		$(use_enable crypt crypto) \
		$(use_enable ntfsprogs) \
		$(use_enable extras) \
		$(use_enable static-libs static) \
		--with-fuse=$(use external-fuse && echo external || echo internal)
}

src_install() {
	default

	use suid && fperms u+s /usr/bin/${MY_PN}

	if use udev; then
		insinto /lib/udev/rules.d
		doins "${FILESDIR}"/99-ntfs3g.rules
	fi

	prune_libtool_files

	# http://bugs.gentoo.org/398069
	dodir /usr/sbin
	mv "${D}"/sbin/* "${ED}"/usr/sbin || die
	rm -rf "${D}"/sbin

	dosym mount.ntfs-3g /usr/sbin/mount.ntfs #374197
}

pkg_postinst() {
	ewarn "This is an advanced features release of the ntfs-3g package. It"
	ewarn "passes standard tests on i386 and x86_64 CPUs but users should"
	ewarn "still backup their data.  More info at:"
	ewarn "http://pagesperso-orange.fr/b.andre/advanced-ntfs-3g.html"
}
