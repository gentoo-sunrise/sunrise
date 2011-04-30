# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MY_P="${P/webcamserver/webcam_server}"

DESCRIPTION="View your webcam from a web browser"
HOMEPAGE="http://webcamserver.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/jpeg"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
