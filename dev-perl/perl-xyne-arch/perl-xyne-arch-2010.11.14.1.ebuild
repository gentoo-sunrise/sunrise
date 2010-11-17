# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit perl-module

DESCRIPTION="Collection of xyne's archlinux-related perl modules"
HOMEPAGE="http://xyne.archlinux.ca/projects/perl-xyne-arch"
SRC_URI="http://xyne.archlinux.ca/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="perl-core/IO
	dev-perl/perl-xyne-common
	dev-perl/URI"

S=${WORKDIR}/${PN}
