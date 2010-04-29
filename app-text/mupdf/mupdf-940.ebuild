# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="a lightweight PDF viewer and toolkit written in portable C"
HOMEPAGE="http://mupdf.com/"
SRC_URI="http://${PN}.com/download/${PN}-r${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cjk jbig jpeg2k"

S=${WORKDIR}/${PN}

RDEPEND="media-libs/freetype:2
	media-libs/jpeg
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	jbig? ( media-libs/jbigkit )
	jpeg2k? ( media-libs/jasper )"
DEPEND="${RDEPEND}
	dev-util/ftjam"

src_compile() {
	cat <<EOF >> Jamrules
LINKFLAGS = ${LDFLAGS} ;
OPTIM = ${CFLAGS} ;
ALL_LOCATE_TARGET = [ FDirName \$(TOP) build ] ;
EOF
	local my_param=""
	use cjk || my_param="'-sDEFINES=NOCJK'"
	use jbig && my_param="${my_param} '-sHAVE_JBIG2DEC=yes'"
	use jpeg2k && my_param="${my_param} '-sHAVE_JASPER=yes'"
	jam ${my_param} || die
}

src_install() {
	dobin build/{{cmap,font}dump,mupdf,pdf{clean,draw,extract,show}} || die
	newbin build/pdfinfo mupdf_pdfinfo || die # avoid collision with app-text/poppler-utils
	dolib build/*.a || die

	dodoc README || die
}
