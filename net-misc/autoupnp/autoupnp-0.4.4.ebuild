# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EMULTILIB_PKG=true
inherit multilib toolchain-funcs

DESCRIPTION="Automatic open port forwarder using UPnP"
HOMEPAGE="http://github.com/mgorny/autoupnp/"
SRC_URI="http://github.com/downloads/mgorny/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libnotify multilib suid"

RDEPEND="net-misc/miniupnpc
	libnotify? ( x11-libs/libnotify )"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC
	emake LIBPREFIX= \
		WANT_LIBNOTIFY=$(use libnotify && echo true || echo false) \
		all $(use suid || echo dummy) || die

	if has_multilib_profile && use multilib; then
		local abi
		for abi in $(get_install_abis); do
			multilib_toolchain_setup ${abi}
			if ! is_final_abi; then
				einfo "Building the dummy lib for ${abi}"
				mkdir "${S}"/${abi} || die
				cd "${S}"/${abi} || die
				emake -f ../Makefile DUMMYLIB=${PN}.so dummy || die
			fi
		done
	fi
}

src_install() {
	emake LIBPREFIX= DESTDIR="${D}" LIBDIRNAME=$(get_libdir) \
		$(use suid && echo install-suid || echo install-dummy) || die

	if has_multilib_profile && use multilib; then
		local abi
		for abi in $(get_install_abis); do
			ABI=${abi}
			is_final_abi || dolib ${abi}/${PN}.so || die
		done
	fi

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
	else
		chmod o+r "${ROOT}"$(get_libdir)/${PN}.so || die
	fi

	if has_multilib_profile && use multilib; then
		elog
		elog "A dummy libraries were installed for your additional ABIs. They will"
		elog "silence the ld.so complaints when running alternate ABI applications"
		elog "but won't bring real UPnP support to them."
	fi
}
