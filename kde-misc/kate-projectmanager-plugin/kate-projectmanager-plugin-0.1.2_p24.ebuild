# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
inherit kde

KEYWORDS="~x86"

MY_PN="projectmanager"

DESCRIPTION="A projectmanager plugin for the KDE editor kate"
HOMEPAGE="http://sourceforge.net/projects/kate-prj-mng"
SRC_URI="mirror://sourceforge/kate-prj-mng/${MY_PN}-${PV/_p/-}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="|| ( kde-base/kate:3.5 kde-base/kdebase:3.5 )"
RDEPEND="${DEPEND}"

need-kde 3.5

S=${WORKDIR}/${MY_PN}
