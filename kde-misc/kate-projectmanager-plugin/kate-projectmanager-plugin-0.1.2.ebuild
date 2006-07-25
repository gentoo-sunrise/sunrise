# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde
need-kde 3.5

MY_PN="projectmanager"

DESCRIPTION="A projectmanager plugin for the KDE editor kate"
HOMEPAGE="http://sourceforge.net/projects/kate-prj-mng"
SRC_URI="mirror://sourceforge/kate-prj-mng/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="|| ( kde-base/kate kde-base/kdebase )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}
