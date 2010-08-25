# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib toolchain-funcs

DESCRIPTION="Automatic open port forwarder using UPnP"
HOMEPAGE="http://github.com/mgorny/autoupnp/"
SRC_URI="http://github.com/downloads/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libnotify suid"

RDEPEND="net-misc/miniupnpc
	libnotify? ( x11-libs/libnotify )"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC
	emake WANT_LIBNOTIFY=$(use libnotify && echo true || echo false) || die

	# In order to run setuid, we need not to provide the full path.
	# Otherwise, we shall do that to avoid ld.so complaining.
	local libpath
	if use suid; then
		libpath=${PN}.so
	else
		libpath=/usr/$(get_libdir)/${PN}.so
	fi

	# Generate the clean wrapper script.
	sh ./autoupnp cleanup ${libpath} "${T}"/${PN} || die
}

src_install() {
	dolib ${PN}.so || die
	if use suid; then
		fperms ug+s /usr/$(get_libdir)/${PN}.so || die
	fi
	dobin "${T}"/${PN} || die

	dodoc NEWS README || die
}

pkg_postinst() {
	elog "Please notice that AutoUPnP was rewritten in the form of a C LD_PRELOAD"
	elog "library, and thus it has to be enabled for a particular program to have"
	elog "its ports redirected. To enable it for the current user, call:"
	elog "	$ autoupnp install"
	if use suid; then
		elog
		ewarn "You have chosen to install ${PN}.so setuid & setgid. Please notice that this"
		ewarn "is discouraged in the terms of security. You have been warned."

		# need to work-around Portage behavior to make ld.so happy (bug #334473)
		chmod o+r "${ROOT}"usr/$(get_libdir)/${PN}.so || die
	fi
}
