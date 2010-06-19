# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
PYTHON_DEPEND="2"

inherit python eutils

DESCRIPTION="Platform independent MSN Messenger client written in Python+GTK"
HOMEPAGE="http://www.emesene.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="webcam"

RDEPEND="dev-python/pygtk:2
	dev-python/gst-python"

src_prepare() {
	rm GPL PSF LGPL || die "rm license files failed"

	if ! use webcam; then
		rm -r libmimic || die "rm libmimic dir failed"
	fi
}

src_compile() {
	if use webcam ; then
		$(PYTHON) ./setup.py build_ext -i || die "libmimic compile failed"
	fi
}

src_install() {
	if use webcam; then
		rm -r build || die "rm build failed"
	fi

	insinto /usr/share/${PN}
	doins -r * || die "doins failed"

	fperms a+x /usr/share/${PN}/${PN} || die "fperms failed"
	dosym /usr/share/${PN}/${PN} /usr/bin/${PN} || die "dosym failed"

	doman misc/${PN}.1 || die "doman failed"

	doicon misc/*.{svg,png} || die "doicon failed"

	# install the desktop entry
	domenu misc/${PN}.desktop || die "domenu failed"
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}

	elog "If you want to use the spell-checking feature, you should emerge"
	elog "dev-python/gtkspell-python"
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}
}
