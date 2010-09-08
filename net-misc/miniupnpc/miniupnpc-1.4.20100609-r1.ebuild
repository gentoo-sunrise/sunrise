# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
SUPPORT_PYTHON_ABIS=1
PYTHON_DEPEND="python? 2"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils multilib python toolchain-funcs

DESCRIPTION="UPnP client library and a simple UPnP client"
SRC_URI="http://miniupnp.free.fr/files/${P}.tar.gz"
HOMEPAGE="http://miniupnp.free.fr/"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="python static-libs"

src_prepare() {
	use python && distutils_src_prepare

	epatch \
		"${FILESDIR}"/0001-Append-miniupnpc-specific-flags-to-CFLAGS.patch \
		"${FILESDIR}"/0002-Respect-LDFLAGS.patch \
		"${FILESDIR}"/0003-Move-non-used-and-non-installed-test-executables-to-.patch \
		"${FILESDIR}"/0004-Move-minixml-validation-test-to-check-target.patch \
		"${FILESDIR}"/0005-Build-upnpc-static-only-on-AmigaOS-or-everything-tar.patch \
		"${FILESDIR}"/0006-Support-disabling-static-library-install-through-LIB.patch
}

src_compile() {
	tc-export CC
	# We need the static library for the Python module.
	emake \
		$(use static-libs || use python || printf 'LIBRARY=') || die
	use python && distutils_src_compile
}

src_install() {
	emake \
		$(use static-libs || printf 'LIBRARY=') \
		PREFIX="${D}" \
		INSTALLDIRLIB="${D}"usr/$(get_libdir) \
		install || die
	dodoc README Changelog.txt || die
	doman man3/* || die
	use python && distutils_src_install
}
