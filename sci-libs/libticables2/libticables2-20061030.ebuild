# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="library to handle different link cables for TI calculators"
HOMEPAGE="http://lpg.ticalc.org/prj_tilp/"
SRC_URI="mirror://sourceforge/gtktiemu/${P}.tar.bz2
	mirror://sourceforge/gtktiemu/${P}-64bit.diff"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls pam_console"

DEPEND=">=dev-libs/glib-2
	dev-libs/libusb
	nls? ( sys-devel/gettext )"

RDEPEND=">=dev-libs/glib-2
	dev-libs/libusb
	pam_console? ( || ( sys-auth/pam_console <sys-libs/pam-0.99 ) )
	nls? ( virtual/libintl )"

S=${WORKDIR}/libticables

pkg_setup() {
	if use pam_console && has_version "<sys-libs/pam-0.99" && ! built_with_use sys-libs/pam pam_console ; then
		eerror "You need to build pam with pam_console support"
		eerror "Please remerge sys-libs/pam with USE=pam_console"
		die "pam without pam_console detected"
	fi
}

src_unpack() {
	unpack "${P}.tar.bz2" 
	cd ${S}
	[[ $(tc-arch) == "amd64" ]] && epatch "${DISTDIR}"/${P}-64bit.diff
}

src_compile() {
	econf $(use_enable nls) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS LOGO NEWS README ChangeLog docs/api.txt
	dohtml docs/html/*
	if use pam_console; then
		insinto /etc/udev/rules.d
		doins "${FILESDIR}"/60-libticables.rules
		insinto /etc/security/console.perms.d
		doins "${FILESDIR}"/60-libticables.perms
	fi
}

pkg_postinst() {
	elog "Please read /usr/share/doc/${PF}/README.gz"
	elog "if you encounter any problem with a link cable"
}
