# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2

DESCRIPTION="A simple, easy to use paint program for GNOME"
HOMEPAGE="http://code.google.com/p/gnome-paint/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.16:2"
RDEPEND="${DEPEND}"
