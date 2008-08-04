# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

DESCRIPTION="Open Field Operation and Manipulation - CFD Simulation Toolbox"
HOMEPAGE="http://www.opencfd.co.uk/openfoam/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="!=sci-libs/openfoam-${PV}*
	!=sci-libs/openfoam-bin-${PV}*
	=sci-libs/openfoam-kernel-${PV}*
	=sci-libs/openfoam-solvers-${PV}*
	=sci-libs/openfoam-utilities-${PV}*
	=sci-libs/openfoam-wmake-${PV}*"
