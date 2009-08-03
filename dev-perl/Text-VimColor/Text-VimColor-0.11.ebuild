# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

MODULE_AUTHOR="GEOFFR"
inherit perl-module

DESCRIPTION="Syntax highlighting using vim"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/Path-Class
	app-editors/vim"
