# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs flag-o-matic autotools fortran

#     DAY         MONTH    YEAR
MY_PV=${PV:4:2}_${PV:6:2}_${PV:0:4}
MY_P=dpsrc.${MY_PV}
MY_P_AUX=dplib.${MY_PV}

DESCRIPTION="A program for scientific visualization and statistical analyis"
HOMEPAGE="http://www.itl.nist.gov/div898/software/dataplot/"
SRC_URI="ftp://ftp.nist.gov/pub/dataplot/unix/dpsrc.${MY_PV}.tar.gz
	ftp://ftp.nist.gov/pub/dataplot/unix/dplib.${MY_PV}.tar.gz"


LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples gd gs opengl X"

COMMON_DEPEND="opengl? ( virtual/opengl )
	gd? ( media-libs/gd )
	gs? ( virtual/ghostscript media-libs/gd )"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	X? ( x11-misc/xdg-utils )"

S="${WORKDIR}/${MY_P}"
S_AUX="${WORKDIR}/${MY_P_AUX}"

pkg_setup() {
	#Dataplot requires media-libs/gd to be built with USE="png jpeg"
	if use gd || use gs; then
		if ! built_with_use -a media-libs/gd png jpeg; then
			eerror "media-libs/gd is not compiled with USE=\"png jpeg\""
			eerror "Please recompile media-libs/gd, ensuring USE=\"png jpeg\""
			die
		fi
	fi
	##FIXME: Just gfortran for now, I'll get to testing g77 later
	NEED_FORTRAN="gfortran"
	fortran_pkg_setup
}

src_unpack() {
	mkdir ${MY_P} && cd "${S}"
	unpack ${MY_P}.tar.gz
	mv DPCOPA.INC DPCOPA.INC.in
	mv dp1_linux.f dp1_linux.f.in
	mv dp1_linux_64.f dp1_linux_64.f.in
	epatch "${FILESDIR}"/dpsrc-patchset-${PV}.patch
	epatch "${FILESDIR}"/dpsrc-maxobvvalue-${PV}.patch
	epatch "${FILESDIR}"/dpsrc-dp1patches-${PV}.patch

	cp "${FILESDIR}"/{Makefile.am,configure.ac} "${S}"

	mkdir "${S_AUX}" && cd "${S_AUX}"
	unpack ${MY_P_AUX}.tar.gz
	cd "${S}"
	eautoreconf
}

src_compile() {
	econf $(use_enable gd) \
		$(use_enable gs) \
		$(use_enable opengl) \
		$(use_enable X)

	emake || die "Make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S_AUX}"/data/* || die "Installing examples failed"
	fi
	insinto /usr/share/dataplot
	doins "${S_AUX}"/dpmesf.tex "${S_AUX}"/dpsysf.tex "${S_AUX}"/dplogf.tex
	doenvd "${FILESDIR}"/90${PN}
}

pkg_postinst() {
	einfo "To avoid error messages on dataplot startup please run(as root): "
	einfo "env-update && source /etc/profile"
	einfo "This is because dataplot installs env.d files for dataplot variables."
}
