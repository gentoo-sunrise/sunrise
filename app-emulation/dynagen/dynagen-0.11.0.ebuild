# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib python

DESCRIPTION="Text-based frontend to Dynamips Cisco router emulator."
HOMEPAGE="http://www.dynagen.org/"
SRC_URI="mirror://sourceforge/dyna-gen/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="app-emulation/dynamips"

src_install() {
	insinto $(python_get_sitedir)
	doins *.py || die "python files install failed"

	dobin ${PN} || die "failed install of /usr/bin/dynagen"

	insinto /etc
	doins ${PN}.ini || die "config file install failed"

	insinto /usr/share/${PN}
	doins configspec || die "failed configspec install"

	dodoc README.txt

	insinto /usr/share/doc/${P}
	doins -r sample_labs
	dohtml -r docs/*
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages
}

pkg_postrm() {
	python_mod_cleanup
}
