# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic
# qt3

DESCRIPTION="A freely available and fully compliant implementation of the CORBA standard"
HOMEPAGE="http://www.mico.org/"
SRC_URI="http://www.mico.org/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk postgres ssl tcl threads" # qt3

DEPEND=">=sys-devel/flex-2.5.2
	>=sys-devel/bison-1.22
	ssl? ( dev-libs/openssl )
	tcl? ( dev-lang/tcl )
	postgres? ( dev-db/postgresql )"
# 	qt3? ( x11-libs/qt )"

S="${WORKDIR}/${PN}"

src_compile() {
	local myopts="--enable-final
		--disable-mini-stl"
#		--enable-life
#		--enable-externalize"

	if ! use threads; then
		myopts="${myopts} --enable-threads=no --enable-pthreads=no"
	fi

	append-flags -fno-strict-aliasing

	econf ${myopts} \
		$(use_with ssl ssl /usr) \
		$(use_with tcl tcl /usr) \
		$(use_with gtk gtk /usr) \
		$(use_with postgres pgsql /usr)
		# $(use_with qt3 qt ${QTDIR}

	# Rather not emake here, as is a memory hog
	make || die "make failed"
}

src_install() {
	emake INSTDIR="${D}"/usr SHARED_INSTDIR="${D}"/usr install || die "install failed"

	dodir /usr/share/
	mv "${D}"/usr/man "${D}"/usr/share
	dodir /usr/share/doc/${PF}
	mv "${D}"/usr/doc "${D}"/usr/share/doc/${PF}

	dodoc BUGS CHANGES* CONVERT FAQ README* ROADMAP TODO VERSION WTODO
}
