# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils

MY_P=${PN}${PV}
DESCRIPTION="A set of extensions to TCL"
HOMEPAGE="http://tclx.sourceforge.net"
SRC_URI="mirror://sourceforge/tclx/${MY_P}.tar.bz2
	ftp://ftp.scriptics.com/pub/tcl/tcl8_4/tcl8.4.6-src.tar.gz
	ftp://ftp.scriptics.com/pub/tcl/tcl8_4/tk8.4.6-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="X"


DEPEND=">=dev-lang/tcl-8.4.6
	X? ( >=dev-lang/tk-8.4.6 )"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	# Fix bug[s] in configure script #119619
	local d
	local srcdirs
	srcdirs="tcl8.4.6/unix tk8.4.6/unix tclx8.4"

	for d in $srcdirs; do
		ebegin "Fixing ${d}/configure"
		cd ${WORKDIR}/${d}
		sed -i -e "/relid'/s/relid'/relid/" configure || die "sed failed to fix
		configure scripts"
		eend $?
	done
}

src_compile() {
	# we have to configure and build tcl before we can do tclx
	cd "${WORKDIR}"/tcl8.4.6/unix
	econf
	emake CFLAGS="${CFLAGS}" || die "emake in tcl/unix failed"

	local myconf="--with-tcl=${WORKDIR}/tcl8.4.6/unix --enable-shared"

	if use X ; then
		# configure and build tk
		cd ${WORKDIR}/tk8.4.6/unix
		econf
		emake CFLAGS="${CFLAGS}" || die "emake X failed"
		myconf="${myconf} --with-tk=${WORKDIR}/tk8.4.6/unix"
	else
		myconf="${myconf} --enable-tk=no"
	fi

	# configure and build tclx
	cd "${S}"
	econf ${myconf}
	emake CFLAGS="${CFLAGS}" || die "emake tclx failed"
}

src_install() {
	cd "${S}"
	emake DESTDIR="${D}" install || die
	dodoc CHANGES README TO-DO doc/CONVERSION-NOTES
	doman doc/*.[n3]
}
