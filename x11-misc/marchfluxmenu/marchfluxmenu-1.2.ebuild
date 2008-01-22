# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python multilib

MY_PN="mfm"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="An attempt to have the fluxbox menu emulate Gnome (or XFCE) menu, in both looks and functionality."
HOMEPAGE="http://code.google.com/p/marchfluxmenu/"
SRC_URI="http://marchfluxmenu.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/python"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.patch
	python_version
	sed -i -e "s:@@PYDIR@@:/usr/$(get_libdir)/python${PYVER}/site-packages:g" \
		installer mfmdaemon || die "failed to fix paths"
}

src_compile() {
	einfo "Nothing to compile, installing..."
}

src_install() {
	dodoc README mfmdaemon

	insinto /usr/share/${PN}
	doins -r icons

	newbin installer ${PN}
	rm -rf COPYING README icons installer main.pyc mfmdaemon

	python_version
	insinto /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
	doins *
}

pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}"usr/$(get_libdir)/python${PYVER}/site-packages/${PN}

	elog "Now just run ${PN} as user to generate your fluxbox menu."
	elog "See README in /usr/share/doc/${PF} for more information on usage."
}

pkg_postrm() {
	python_mod_cleanup
}
