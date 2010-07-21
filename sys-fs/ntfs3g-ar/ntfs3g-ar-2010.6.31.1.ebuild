# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit linux-info versionator

MY_PN="${PN/3g-ar/-3g}"
MY_PV="$(get_version_component_range 1-3)AR.$(get_version_component_range 4)"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="NTFS-3G variant supporting ACLs, junction points, compression and more"
HOMEPAGE="http://pagesperso-orange.fr/b.andre/advanced-ntfs-3g.html"
SRC_URI="http://pagesperso-orange.fr/b.andre/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="acl debug external-fuse hal suid udev"

RDEPEND="external-fuse? ( >=sys-fs/fuse-2.8.0 )
	hal? ( sys-apps/hal )
	!sys-fs/ntfs3g
	sys-apps/attr"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

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
		--docdir="/usr/share/doc/${PF}" \
		--enable-ldscript \
		--disable-ldconfig \
		--with-fuse=$(use external-fuse && echo external || echo internal) \
		$(use_enable acl posix-acls) \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	prepalldocs || die "prepalldocs failed"
	dodoc AUTHORS ChangeLog CREDITS || die "dodoc failed"

	use suid && { fperms u+s "/bin/${MY_PN}" || die "set suid failed" ; }

	if use hal; then
		insinto /etc/hal/fdi/policy/
		newins "${FILESDIR}/10-ntfs3g.fdi.2009-r1" "10-ntfs3g.fdi" || die "hal fdi install failed"
	fi

	if use udev; then
		insinto /etc/udev/rules.d/
		doins "${FILESDIR}/99-ntfs3g.rules" || die "udev rules install failed"
	fi
}

pkg_postinst() {
	ewarn "This is an advanced features release of the ntfs-3g package. It"
	ewarn "passes standard tests on i386 and x86_64 CPUs but users should"
	ewarn "still backup their data.  More info at:"
	ewarn "http://pagesperso-orange.fr/b.andre/advanced-ntfs-3g.html"

	if use suid; then
		ewarn
		ewarn "You have chosen to install ${PN} with the binary setuid root. This"
		ewarn "means that if there any undetected vulnerabilities in the binary,"
		ewarn "then local users may be able to gain root access on your machine."
	fi
}
