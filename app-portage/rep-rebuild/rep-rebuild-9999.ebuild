# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ECVS_SERVER="rep-rebuild.cvs.sourceforge.net:/cvsroot/rep-rebuild"
ECVS_MODULE=${PN}
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"
inherit cvs

DESCRIPTION="A tool to rebuild SVN/CVS packages taking care of dependencies ordering"
HOMEPAGE="http://sourceforge.net/projects/rep-rebuild/"

LICENSE="LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="dev-perl/PortageXS
	app-portage/gentoolkit
	dev-lang/perl"
DEPEND=""

S="${WORKDIR}/${ECVS_MODULE}"

src_install() {
	dobin bin/rep-rebuild || die "dobin failed"
	doman man/rep-rebuild.1
	dodoc doc/{README,CREDITS}
}
