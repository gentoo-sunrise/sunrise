# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde

DESCRIPTION="A commandline client to KDE's addressbook"
HOMEPAGE="http://www.sbox.tugraz.at/home/v/voyager/kabcclient/"
SRC_URI="http://www.sbox.tugraz.at/home/v/voyager/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND="|| ( kde-base/kaddressbook kde-base/kdepim )"
RDEPEND="${DEPEND}"

need-kde 3.4.2
