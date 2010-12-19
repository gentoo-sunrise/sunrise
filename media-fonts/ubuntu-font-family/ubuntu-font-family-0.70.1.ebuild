# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit font

DESCRIPTION="A set of matching libre/open fonts funded by Canonical"
HOMEPAGE="https://wiki.ubuntu.com/Ubuntu%20Font%20Family"
SRC_URI="ftp://ftp.ubuntu.com/ubuntu/pool/main/u/${PN}-sources/${PN}-sources_${PV}.orig.tar.gz"
LICENSE="UbuntuFontFamily"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

FONT_SUFFIX="ttf"
S="${WORKDIR}/${PN}-sources-${PV}"

DOCS="CONTRIBUTING.txt copyright.txt LICENCE-FAQ.txt TRADEMARKS.txt"
