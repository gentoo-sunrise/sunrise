# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cmake-utils

DESCRIPTION="Toolset to accelerate the boot process and application startup"
HOMEPAGE="http://e4rat.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}_src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
	>=dev-libs/boost-1.41
	sys-fs/e2fsprogs
	sys-process/audit"

RDEPEND="${DEPEND}"

CMAKE_BUILD_TYPE=release
PATCHES=( "${FILESDIR}/cmake_mkdir_violation_fix.patch"
	"${FILESDIR}/v0.2_as-needed_fix.patch"
	"${FILESDIR}/fix_manpage_source_path.patch" )
