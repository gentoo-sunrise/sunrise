# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-ext

DESCRIPTION="EPIC is an opensource Perl IDE for the Eclipse platform."
HOMEPAGE="http://e-p-i-c.sourceforge.net/"
SRC_URI="http://e-p-i-c.sourceforge.net/downloads/org.epic.updatesite_${PV}_20040711.zip"
LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="app-arch/unzip
	sys-apps/findutils"
RDEPEND=">=dev-util/eclipse-sdk-3.0.0
	dev-lang/perl"
S=${WORKDIR}/org.epic.updatesite

src_unpack() {
	unpack ${A}
	cd "${S}"

	for jar in `find . -iname *.jar`; do
		unzip ${jar} -d ${jar%.jar}
		rm ${jar}
	done
}

src_install() {
	eclipse-ext_require-slot 3 || die "Failed to find suitable Eclipse installation"

	eclipse-ext_create-ext-layout binary || die "Failed to create layout"

	eclipse-ext_install-features features/* || die "Failed to install features"
	eclipse-ext_install-plugins plugins/* || die "Failed to install plugins"
}
