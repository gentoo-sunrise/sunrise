# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2 mono

KEYWORDS="~x86"

DESCRIPTION="LDAP Administration Tool, allows you to browse LDAP-based directories and add/edit/delete entries."
HOMEPAGE="http://dev.mmgsecurity.com/projects/lat"
SRC_URI="http://dev.mmgsecurity.com/downloads/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
IUSE=""
SLOT="0"

RDEPEND=">=dev-lang/mono-1.1.12.1
		>=dev-dotnet/gtk-sharp-2.4.2
		>=dev-dotnet/gnome-sharp-2.4.2
		>=dev-dotnet/glade-sharp-2.4.2
		>=dev-dotnet/gconf-sharp-2.4.2
		>=gnome-base/gnome-keyring-0.4.2"
DEPEND="${RDEPEND}
		app-text/scrollkeeper
		dev-util/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README TODO"
