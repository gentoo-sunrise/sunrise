# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A small, lightweight to-do list for Gnome"
HOMEPAGE="http://pimlico-project.org/tasks.html"
SRC_URI="http://pimlico-project.org/sources/tasks/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=gnome-extra/evolution-data-server-1.8.2
	>=x11-libs/gtk+-2.6
	x11-libs/libsexy"

DEPEND="${RDEPEND}
		sys-apps/gawk
		sys-apps/grep
		>=dev-util/pkgconfig-0.9.0
		dev-lang/perl
		dev-perl/XML-Parser
		dev-util/intltool
		sys-devel/gettext"

DOCS="AUTHORS ChangeLog INSTALL NEWS README TODO"
