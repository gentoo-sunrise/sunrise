# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base versionator

MY_P=${PN}-$(replace_version_separator 2 '-')

DESCRIPTION="Pidgin plugin to capture a rectangular area of your screen and send it"
HOMEPAGE="http://raoulito.info/plugins/pidgin_screenshot/"
SRC_URI="http://raoulito.info/plugins/${PN/-send/_}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="net-im/pidgin[gtk]
	net-misc/curl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog README )
