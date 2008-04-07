# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs flag-o-matic

MY_PV=06SEPpl1.0

DESCRIPTION="general tools for image processing and data reduction with emphasis
on astronomical applications"
HOMEPAGE="http://www.eso.org/projects/esomidas/"
SRC_URI="ftp://ftphost.hq.eso.org/pub/midaspub/${MY_PV%pl*}/sources/${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="x11-libs/libXt
	x11-libs/libX11
	x11-libs/openmotif
	sys-libs/ncurses
	sys-libs/readline"
RDEPEND="${DEPEND}
	x11-apps/xwininfo"

S=${WORKDIR}/${MY_PV}

src_unpack() {
	unpack $A
	cd "${S}"
	epatch "${FILESDIR}/${P}-compile.patch"
}

src_compile() {
	cd "${S}/install/unix"

	# this flags failed @@ veriall
	replace-flags -O[2-9] -O1

	sed -i \
		-e "s/^\(CC =\).*/\1 $(tc-getCC)/" \
		-e "s/^\(LDCC =\).*/\1 $(tc-getCC)/" \
		-e "s/^\(F77 =\).*/\1 $(tc-getF77)/" \
		-e "s/^\(LD77_CMD =\).*/\1 $(tc-getF77)/" \
		-e "s/^\(RANLIB =\).*/\1 $(tc-getRANLIB)/" \
		-e "s/^\(AR =\).*/\1 $(tc-getAR)/" \
		-e "s/^\(C_OPT =\).*/\1 ${CFLAGS}/" \
		-e "s/^\(F_OPT =\).*/\1 ${F77FLAGS}/" \
		-e "s/^\(STRIP =\).*/\1 true/" \
		default_mk || die "sed failed"
	sed -i \
		-e "s/^\(F77=\).*/\1 $(tc-getF77)/" \
		-e "s/^\(LD77_CMD=\).*/\1 $(tc-getF77)/" \
		-e "s/^\(C_OPT=\).*/\1 ${CFLAGS}/" \
		-e "s/^\(F_OPT=\).*/\1 ${F77FLAGS}/" \
		-e "s/^\(SLIB=\).*/\1/" \
		systems/Linux{,_alpha,_AMD64}/make_options || die "sed failed"

	./autoconfig

	sed -i \
		-e "s#^\(MIDASHOME0=\).*#\1/usr/share/${PN}#" \
		"${S}"/system/unix/{drs,helpmidas,inmidas} || die "sed failed"
}

src_install() {
	exeinto /usr/share/${PN}/${MY_PV}/system/unix
	insinto /usr/share/${PN}/${MY_PV}/system/unix
	doexe "${S}"/system/unix/{nmgrep,inmidas,gomidas,add_sccs,helpmidas,originator}
	doexe "${S}"/system/unix/{environment,patchlevel,cleanmidas,make_midfile,drs,ld77}
	for i in inmidas gomidas helpmidas; do
		dosym /usr/share/${PN}/${MY_PV}/system/unix/${i} /usr/bin/${i}
	done

	for dir in system prim applic stdred gui util; do
		exeinto /usr/share/${PN}/${MY_PV}/"${dir}"/exec
		doexe "${S}"/${dir}/exec/*.exe
	done

	for dir in prim applic stdred contrib gui; do
		insinto /usr/share/${PN}/${MY_PV}/"${dir}"/proc
		for i in "${S}"/"${dir}"/proc/*.{prg,cod,prg_o,sh}; do
			[ -f ${i} ] && doins ${i}
		done
	done

	for dir in prim applic util; do
		insinto /usr/share/${PN}/${MY_PV}/"${dir}"/help
		for i in "${S}"/"${dir}"/help/*.{hlc,hlq,alq,hlz,txt}; do
			[ -f ${i} ] && doins ${i}
		done
	done

	for dir in astromet cloud daophot esolv geotest imres invent iue lyman mva \
		pepsys romafot surfphot template tsa wavelet; do
		insinto /usr/share/${PN}/${MY_PV}/contrib/"${dir}"/help
		for i in "${S}"/contrib/"${dir}"/help/*.{hlc,hlq,alq,hlz,txt}; do
			[ -f ${i} ] && doins ${i}
		done
	done

	for dir in XAlice XBatch XDo XEchelle XFilter XIdent XIrspec XLong; do
		insinto /usr/share/${PN}/${MY_PV}/gui/"${dir}"/help
		for i in "${S}"/gui/"${dir}"/help/*.{hlc,hlq,alq,hlz,txt}; do
			[ -f ${i} ] && doins ${i}
		done
	done

	for dir in ccdred ccdtest do echelle feros irac2 irspec long mos optopus \
		pisco qc spec; do
		insinto /usr/share/${PN}/${MY_PV}/stdred/"${dir}"/help
		for i in "${S}"/stdred/"${dir}"/help/*.{hlc,hlq,alq,hlz,txt}; do
			[ -f ${i} ] && doins ${i}
		done
	done

	exeinto /usr/share/${PN}/${MY_PV}/system/exec
	insinto /usr/share/${PN}/${MY_PV}/system/exec
	doexe system/exec/{crea_{alll,hlq},ftoc_{nam,noop,params},hlqtohlc}
	doins system/exec/*.sh

	dolib "${S}"/lib/*.so*

	exeinto /usr/share/${PN}/${MY_PV}/monit
	insinto /usr/share/${PN}/${MY_PV}/monit
	doexe "${S}"/monit/*.exe
	doexe "${S}"/monit/calib_build
	doins "${S}"/monit/*.{sh,bin}
	doins "${S}"/monit/{syskeys.unix,xnews.txt,FORGRdrs.KEY}

	insinto /usr/share/${PN}/${MY_PV}/outside
	doins "${S}"/outside/{outside_setup,pixcheck,rdscr}

	insinto /usr/share/${PN}/${MY_PV}/prim/proc
	doins "${S}"/prim/proc/compile.all

	insinto /usr/share/${PN}/${MY_PV}/prim/proc/pipeline
	doins "${S}"/prim/proc/pipeline/*.{prg,sh,bconnect,control,start,txt}

	insinto /usr/share/${PN}/${MY_PV}/prim/proc/setup
	doins "${S}"/prim/proc/setup/*.prg

	insinto /usr/share/${PN}/${MY_PV}/systab
	doins -r "${S}"/systab/*

	insinto /usr/share/${PN}/${MY_PV}/test/prim
	doins "${S}"/test/prim/*.{mt,fits,tfits,ffits,dat,fmt,asc,prg,ctx}

	insinto /usr/share/${PN}/${MY_PV}/test/fits
	doins "${S}"/test/fits/*.{mt,dat,prg}

	insinto /usr/share/${PN}/${MY_PV}/incl
	doins "${S}"/incl/*.dat

	insinto /usr/share/${PN}/${MY_PV}/context
	doins "${S}"/context/*.ctx

	insinto /usr/share/${PN}/${MY_PV}/gui/resource
	doins "${S}"/gui/resource/*

	insinto /usr/share/${PN}/${MY_PV}
	doins -r "${S}"/systab

	doman "${S}"/system/unix/man1/{gomidas,helpmidas,inmidas}.1
}
