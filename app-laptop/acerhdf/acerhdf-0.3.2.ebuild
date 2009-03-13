# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit linux-mod

MY_PN="${PN}_kmod"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A kernelmodule which monitors the temperature of the aspire one netbook"
HOMEPAGE="http://piie.net/index.php?section=acerhdf"
SRC_URI="http://piie.net/files/${MY_P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
RDEPEND=""

S="${WORKDIR}/${MY_PN}"

BUILD_TARGETS="default"
MODULE_NAMES="${PN}(:${S}:${S})"
MODULESD_ACERHDF_DOCS="README.txt"
