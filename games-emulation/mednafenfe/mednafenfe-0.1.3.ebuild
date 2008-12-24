# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A mednafen frontend / launcher."
HOMEPAGE="http://mednafenfe.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/mfe-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="games-emulation/mednafen
	dev-python/configobj
	dev-python/pygtk"

S="${WORKDIR}/mfe-${PV}"
