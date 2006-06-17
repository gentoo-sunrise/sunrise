# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P/_rc/-rc}"

DESCRIPTION="Background browser and setter for X windows."
HOMEPAGE="http://www.minuslab.net/code/nitrogen/"
SRC_URI="http://www.minuslab.net/code/nitrogen/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.6
	>=dev-libs/glib-2.6
	>=x11-libs/gtk+-2.6"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
