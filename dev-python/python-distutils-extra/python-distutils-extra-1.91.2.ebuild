# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Enhancements to the Python build system"
HOMEPAGE="http://packages.debian.org/sid/python-distutils-extra"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# intltool is really required during the runtime.
RDEPEND=">=dev-util/intltool-0.35.5"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}"/debian
DOCS=doc/*

