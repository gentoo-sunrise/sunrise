# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="Dina is a monospace bitmap font, primarily aimed at programmers."
HOMEPAGE="http://www.donationcoder.com/Software/Jibz/Dina/index.html"
SRC_URI="http://omploader.org/vMjIwNA/dina-pcf-${PV}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/Dina-PCF
FONT_S=${WORKDIR}/Dina-PCF
FONT_SUFFIX="pcf"

