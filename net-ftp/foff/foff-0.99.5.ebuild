# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils python multilib

DESCRIPTION="FTP client in Python and GTK."
HOMEPAGE="http://foff.sourceforge.net/"
SRC_URI="mirror://sourceforge/foff/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
S=${WORKDIR}/${PN}

RDEPEND=">=dev-lang/python-2.3
	>=dev-python/pygtk-2.6"
DEPEND="${RDEPEND}"

src_install() {
	python_version
	# Copying.txt is needed by the about window
	insinto "/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
	doins *.py foff_logo00.png *.glade *.gladep Copying.txt

	make_wrapper foff "/usr/bin/python /usr/$(get_libdir)/python${PYVER}/site-packages/${PN}/${PN}.py" \
		/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}

	dodoc Readme.txt ChangeLog.txt
}

pkg_postinst() {
	python_version
	python_mod_optimize "${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
}

pkg_postrm() {
	python_version
	python_mod_cleanup "${ROOT}/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}"
}
