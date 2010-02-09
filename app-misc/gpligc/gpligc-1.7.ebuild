# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PN="GPLIGC"
MY_P="${MY_PN}-${PV}-src"
DESCRIPTION="provides IGC-file (GPS tracklog) evaluation and 3D visualisation"
HOMEPAGE="http://gpligc.sf.net/"
SRC_URI="http://pc12-c714.uibk.ac.at/GPLIGC/download/${MY_P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/opengl
	virtual/glut
	virtual/glu
	media-libs/jpeg"
RDEPEND="${DEPEND}
	>=dev-lang/perl-5.6
	dev-perl/perl-tk
	sci-visualization/gnuplot"

# for historical reasons the original tarball has capital letters
# and so has the toplevel directory
S="${WORKDIR}/${MY_P}"

src_compile() {
	emake -C openGLIGCexplorer CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" || die "Build failed"
}

src_install() {
	# create openGLIGCexplorer data dirs
	keepdir /usr/share/${PN}/data/map
	keepdir /usr/share/${PN}/data/airspace
	keepdir /usr/share/${PN}/data/dem
	keepdir /usr/share/${PN}/data/waypoint

	# paths to perl modules have to be set in scripts/modules
	sed -i -e "s:PREFIX:/usr:g" openGLIGCexplorer/.openGLIGCexplorerrc || die "sed failed"
	sed -i -e "s:zzLIBDIRzz:/usr/share/${PN}/:g" GPLIGC/GPLIGC.pl || die "sed failed"
	sed -i -e "s:zzLIBDIRzz:/usr/share/${PN}/:g" GPLIGC/GPLIGCwaypoints.pm || die "sed failed"

	# install binaries and scripts
	dobin GPLIGC/{GPLIGC,gpsp2igc,gpsp2igcfile,gpsp2kml}.pl \
		openGLIGCexplorer/{openGLIGCexplorer,createworld,etopo2merger,optimizer} \
			|| die "dobin failed"

	# install perl modules and icons/pics and sample configuration
	insinto /usr/share/${PN}
	doins GPLIGC/{{GPLIGCfunctions,GPLIGCwaypoints}.pm,gpligc.xbm,icon.png,logo.jpg,logos.gif,logos.jpg} \
		openGLIGCexplorer/.openGLIGCexplorerrc || die "doins failed"

	dodoc doc/{CHANGES,GPLIGC_Manual.pdf} || die "dodoc failed"

	# some symlinks
	dosym /usr/bin/GPLIGC.pl /usr/bin/GPLIGC || die "dosym failed"
	dosym /usr/bin/openGLIGCexplorer /usr/bin/ogie || die "dosym failed"
}

pkg_postinst() {
	einfo
	einfo "Information about using and configuring GPLIGC and"
	einfo "openGLIGCexplorer (ogie) can be found in the provided manual:"
	einfo "/usr/share/doc/${P}/GPLIGC_Manual.pdf"
	einfo "Users should copy ogie's example configuration file from"
	einfo "/usr/share/${PN}/.openGLIGCexplorerrc to the own HOME directory"
	einfo "and edit it according to their needs."
	einfo
}
