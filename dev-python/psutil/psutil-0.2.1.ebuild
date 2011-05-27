# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND='*'
SUPPORT_PYTHON_ABIS=1

inherit distutils python

DESCRIPTION="Retrieve information on running processes and system utilization"
HOMEPAGE="http://code.google.com/p/psutil/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
