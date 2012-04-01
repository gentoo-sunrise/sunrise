# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND="2"

inherit eutils python

DESCRIPTION="A utility to find various forms of lint on a filesystem"
HOMEPAGE="http://www.pixelbeat.org/fslint/"
SRC_URI="http://www.pixelbeat.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND="dev-python/pygtk:2"

src_prepare() {
	python_convert_shebangs -r 2 .
	# change some paths to make fslint-gui run when installed in /usr/bin
	sed -e "s:^liblocation=.*$:liblocation='${EROOT}usr/share/${PN}' #Gentoo:" \
		-e "s:^locale_base=.*$:locale_base=None #Gentoo:" \
		-i fslint-gui || die "sed failed"
}

src_install() {
	# the only sane way of installing dozens of files, most (but not all!)
	# of them executable scripts, spread over multiple subdirectories
	dodir /usr/share/${PN}
	cp -R ${PN}/ "${ED}"/usr/share/${PN} || die "cp failed"

	insinto /usr/share/${PN}
	doins ${PN}{.glade,.gladep,_icon.png} || die "doins failed"

	dobin ${PN}-gui || die "dobin failed"

	doicon ${PN}_icon.png || die "doicon failed"
	domenu ${PN}.desktop || die "domenu failed"

	dodoc doc/{FAQ,NEWS,README,TODO} || die "dodoc failed"
	doman man/{fslint.1,fslint-gui.1} || die "doman failed"

	if use nls ; then
		cd po
		emake DESTDIR="${D}" install || die "locales install failed"
	fi
}
