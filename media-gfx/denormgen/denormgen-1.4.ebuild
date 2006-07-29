# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="creates normal/height maps from high resolution meshes for games or 3d applications"
HOMEPAGE="http://epsylon.rptd.dnsalias.net/denormgen.php"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=x11-libs/fox-1.2"
DEPEND=">=x11-libs/fox-1.2"

src_unpack(){
	unpack ${A}
	cd ${S}
	eautoreconf
}

src_install(){
	emake DESTDIR=${D} install || die "emake failed"
	
	# http://bugs.gentoo.org/show_bug.cgi?id=134456#c7
	#
	# the blender build does not yet have a fixed place
	# where scripts go into. the 2.41 version uses
	# /usr/lib/blender/scripts but the next version already uses
	# /usr/share/blender/scripts/ . once this directory
	# is fixed the following line has to be changed
	# to copy the script into the right place instead
	# of the current placeholder directory.
	insinto /usr/share/${P}/scripts
	doins scripts/dragengine_dim_export.py

	dodoc AUTHORS ChangeLog README TODO
}
