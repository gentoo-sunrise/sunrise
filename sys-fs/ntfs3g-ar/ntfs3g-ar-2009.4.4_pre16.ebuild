# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MY_P=${PN/3g-ar/-3g}-${PV/_pre/AR.}

DESCRIPTION="NTFS-3G variant supporting ACLs, junction points, compression and more"
HOMEPAGE="http://pagesperso-orange.fr/b.andre/advanced-ntfs-3g.html"
SRC_URI="http://pagesperso-orange.fr/b.andre/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug hal suid"

RDEPEND="hal? ( sys-apps/hal )
	sys-fs/fuse
	!sys-fs/ntfs3g"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		--docdir="/usr/share/doc/${PF}" \
		--enable-ldscript \
		--disable-ldconfig \
		--with-fuse=external \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	prepalldocs || die "prepalldocs failed"
	dodoc AUTHORS ChangeLog CREDITS || die "dodoc failed"

	if use suid; then
		fperms u+s "/bin/${PN/3g-ar/-3g}" || die "could not change file permisions"
	fi

	if use hal; then
		insinto /etc/hal/fdi/policy/
		newins "${FILESDIR}/10-ntfs3g.fdi.2009" "10-ntfs3g.fdi" || die "installation of 10-ntfs3g.fdi.2009 failed"
	fi
}

pkg_postinst() {
	ewarn "This is an advanced features release of the ntfs-3g package. It"
	ewarn "passes standard tests on i386 and x86_64 CPUs but users should"
	ewarn "still backup their data.  More info at:"
	ewarn "http://pagesperso-orange.fr/b.andre/advanced-ntfs-3g.html"

	if use suid; then
		ewarn
		ewarn "You have chosen to install ntfs-3g with the binary setuid root. This"
		ewarn "means that if there any undetected vulnerabilities in the binary,"
		ewarn "then local users may be able to gain root access on your machine."
	fi
}
