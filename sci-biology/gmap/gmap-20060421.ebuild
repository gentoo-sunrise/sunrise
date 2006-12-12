DESCRIPTION="A Genomic Mapping and Alignment Program for mRNA and EST Sequences"
LICENSE="gmap"
HOMEPAGE="http://www.gene.com/share/gmap/"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

RESTRICT="nomirror"

inherit versionator

MY_P="`expr substr ${PV} 1 4`-`expr substr ${PV} 5 2`-`expr substr ${PV} 7 2`"
SRC_URI="http://www.gene.com/share/gmap/src/gmap-${MY_P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_P}"

src_install() {
	make install DESTDIR=${D} || die
}
