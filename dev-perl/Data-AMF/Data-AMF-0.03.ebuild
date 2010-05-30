# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MODULE_AUTHOR=BDFOY
inherit perl-module

DESCRIPTION="(de)serializer perl module for Adobe's AMF (Action Message Format)"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="dev-perl/DateTime
	dev-perl/Moose
	dev-perl/UNIVERSAL-require
	dev-perl/XML-LibXML"

SRC_TEST="do"
