# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils gnome2

MY_P="ubuntulooks_${PV}"
DESCRIPTION="Ubuntu GTK+ theme based on famous Clearlooks."
HOMEPAGE="http://www.ubuntu.com/testing/flight5#head-8e514c39116551b6503ac8bc874d7d6d143657e4"
SRC_URI="http://archive.ubuntu.com/ubuntu/pool/main/u/ubuntulooks/${MY_P}.orig.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
S=${WORKDIR}/${MY_P/_/-}
DEPEND=">=x11-themes/gtk-engines-2.6.5
	>=x11-libs/gtk+-2.8.8"
