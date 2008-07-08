# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

S="${WORKDIR}/${P}/src/=build"
DESCRIPTION="Revision control system ideal for widely distributed development"
HOMEPAGE="http://savannah.gnu.org/projects/gnu-arch http://wiki.gnuarch.org/ http://arch.quackerhead.com/~lord/"
SRC_URI="http://ftp.gnu.org/gnu/gnu-arch/${P}.tar.gz
	http://gentooexperimental.org/~patrick/tla.1-2.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~sh ~sparc ~x86"
IUSE="doc"

DEPEND="sys-apps/coreutils
	sys-apps/diffutils
	sys-devel/patch
	sys-apps/findutils
	sys-apps/gawk
	app-arch/tar
	sys-apps/util-linux
	sys-apps/debianutils
	sys-devel/make"

src_unpack() {
	unpack ${P}.tar.gz
	unpack tla.1-2.gz
	mkdir "${S}"
	cd "${WORKDIR}/${P}"
	sed -i 's:/home/lord/{install}:/usr:g' "${WORKDIR}/${P}/src/tla/=gpg-check.awk"
}

src_compile() {
	OPTIONS="--prefix=/usr --with-posix-shell=/bin/bash "

	if [[ -n $CC ]]
	then
	      	../configure ${OPTIONS} --with cc="$CC $CFLAGS" || die "configure failed"
	else
		../configure ${OPTIONS} || die "configure failed"
	fi
	# parallel make may cause problems with this package
	make || die "make failed"
}

src_install () {
	make install prefix="${D}/usr" || die "make install failed"

	cd "${S}"/..
	dodoc ChangeLog

	if use doc; then
		cd docs-tla
		docinto html
		dohtml -r .

		cd ../docs-hackerlab
		docinto hackerlab/html
		dohtml html/*
		docinto hackerlab/ps
		dodoc ps/*
	fi

	cd "${WORKDIR}"
	mv tla.1-2 tla.1
	doman tla.1

	chmod 755 "${WORKDIR}/${P}/src/tla/=gpg-check.awk"
	cp -pPR "${WORKDIR}/${P}/src/tla/=gpg-check.awk" "${D}/usr/bin/tla-gpg-check.awk"
}
