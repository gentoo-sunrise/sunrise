# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-info

MY_P=${PN/3g-ar/-3g}-${PV/_pre/AR.}

DESCRIPTION="Open source read-write NTFS driver that runs under FUSE"
HOMEPAGE="http://www.ntfs-3g.org"
SRC_URI="http://pagesperso-orange.fr/b.andre/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug hal suid"

[[ ${KERNEL} == "linux" ]] && IUSE="${IUSE} fuse"

RDEPEND="hal? ( sys-apps/hal )
	!kernel_linux? ( sys-fs/fuse )
	fuse? ( sys-fs/fuse )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use kernel_linux ; then
		CONFIG_CHECK="~FUSE_FS"
		WARNING_FUSE_FS="This build of ntfs-3g will continue but your kernel needs to be built
			with FUSE support for it to function at runtime."
		linux-info_pkg_setup
	fi
}

src_compile() {
	local myconf

	( !kernel_linux || use fuse ) && myconf="--with-fuse=external"

	econf \
		--docdir="/usr/share/doc/${PF}" \
		--enable-ldscript \
		--disable-ldconfig \
		$(use_enable debug) \
		${myconf}
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	prepalldocs || die "prepalldocs failed"
	dodoc AUTHORS ChangeLog CREDITS || die "dodoc failed"

	use suid && { fperms u+s "/bin/${PN/3g-ar/-3g}" || die "could not change file permisions"; }

	if use hal; then
		insinto /etc/hal/fdi/policy/
		newins "${FILESDIR}/10-ntfs3g.fdi.2009" "10-ntfs3g.fdi" || die "installation of 10-ntfs3g.fdi.2009 failed"
	fi
}

pkg_postinst() {
	ewarn
	ewarn "This is an advanced features release of the ntfs-3g package. It"
	ewarn "passes standard tests on i386 and x86_64 CPUs but users should"
	ewarn "still backup their data.  More info at:"
	ewarn "http://pagesperso-orange.fr/b.andre/advanced-ntfs-3g.html"
	ewarn

	if  ! use kernel_linux || use fuse  ; then
		ewarn
		ewarn "ntfs-3g has been built with external FUSE support."
		ewarn "If your system's FUSE package gets updated please rebuild ntfs-3g,"
		ewarn "as failure to do so may break ntfs-3g functionality."
		ewarn
	fi

	if use suid; then
		ewarn
		ewarn "You have chosen to install ntfs-3g with the binary setuid root. This"
		ewarn "means that if there any undetected vulnerabilities in the binary,"
		ewarn "then local users may be able to gain root access on your machine."
		ewarn
	fi
}
