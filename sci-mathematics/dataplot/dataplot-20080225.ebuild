# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils fortran toolchain-funcs

## PVD->Day component
## PVM->Month component
## PVY->Year component
MY_PVD="${PV:6:2}"
MY_PVM="${PV:4:2}"
MY_PVY="${PV:0:4}"
MY_PV="${MY_PVM}_${MY_PVD}_${MY_PVY}"

DESCRIPTION="A statistics plotter"
HOMEPAGE="http://www.itl.nist.gov/div898/software/dataplot/"
SRC_URI="ftp://ftp.nist.gov/pub/dataplot/unix/dpsrc.${MY_PV}.tar.gz
	examples? ( ftp://ftp.nist.gov/pub/dataplot/unix/dplib.${MY_PV}.tar.gz )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gd opengl X"

DEPEND="${RDEPEND}"
RDEPEND="X? ( x11-libs/libX11 )
	opengl? ( virtual/opengl )
	gd? ( media-libs/gd )"

S="${WORKDIR}/dpsrc"
LIBS="${WORKDIR}/dplib"

pkg_setup() {
	#Dataplot requires media-libs/gd to be built with USE="png jpeg"
	if ! built_with_use -a media-libs/gd png jpeg; then
		eerror "media-libs/gd is not compiled with USE=\"png jpeg\""
		eerror "Please recompile media-libs/gd, ensuring USE=\"png jpeg\""
		die
	fi

	need_fortran gfortran
}

src_unpack() {
	mkdir dpsrc && cd "${S}"
	unpack dpsrc.${MY_PV}.tar.gz
	##Arches!: Add your architecture name here in the braces if you are 64-bit!
	if use {amd64}; then
		cp dp1_linux_64.f dp1.f
		cp DPCOPA_BIG.INC DPCOPA.INC
	else
		cp dp1_linux.f dp1.f
	fi

	epatch "${FILESDIR}/dpsrc-patchset-${PV}.patch"
	if use examples; then
		mkdir "${LIBS}" && cd "${LIBS}"
		unpack dplib.${MY_PV}.tar.gz
	fi
}

src_compile() {
	FFLAGS="${FFLAGS} -fno-range-check -c"

	for i in {1..46}; do
		FORTRANSOURCES+="dp${i}.f "
	done

	FORTRANSOURCES+=" dpcalc.f dpdds2.f dpdds3.f
	dpdds.f edinit.f edmai2.f edsear.f
	edsub.f edwrst.f fit3b.f gl_src.f
	starpac.f tcdriv_nopc.f aqua_src.f"

	for i in ${FORTRANSOURCES}; do
		einfo "Compiling ${i}..."
		$FORTRANC -w ${FFLAGS} ${i} || die "Fortran Compile failed for file: ${i}"
	done

	use X && LDFLAGS="${LDFLAGS} -L/usr/$(get_libdir) -lX11"
	use opengl  && LDFLAGS="${LDFLAGS} -L/usr/$(get_libdir)/opengl/xorg-x11/lib -lGL -lGLU"
	use gd && LDFLAGS="${LDFLAGS} -lgd -lpng -ljpeg -lz"

	##Compile x11/gd/opengl device drivers

	if use gd; then
		$(tc-getCC) -c ${CFLAGS} -I/usr/include/GL gd_src.c || die "Compiling gd_src.c
		failed!"
	else
		${FORTRANC} ${FFLAGS} gd_src.f || die "Compiling gd_src.f failed!"
	fi

	if use opengl; then
		$(tc-getCC) -c ${CFLAGS} -DUNIX_OS -DAPPEND_UNDERSCORE \
		-DSUBROUTINE_CASE gl_src.c || die "Compiling gl_src.c
		failed!"
	else
		${FORTRANC} ${FFLAGS} gl_src.f || die "Compiling gl_src.f failed!"
	fi

	if use X; then
		$(tc-getCC) -c ${CFLAGS} -I/usr/include/X11 x11_src.c || die "Compiling x11_src.c
		failed!"
	else
		${FORTRANC} ${FFLAGS} x11src.f || die "Compiling x11_src.f failed!"
	fi

	#Link!
	${FORTRANC} -o dataplot main.f *.o ${LDFLAGS} || die "Linking failed!"
}

src_install() {
	dobin dataplot

	if use examples; then
		cd "${LIBS}"
		insinto /usr/share/${PN}
		doins -r data
	fi
}
