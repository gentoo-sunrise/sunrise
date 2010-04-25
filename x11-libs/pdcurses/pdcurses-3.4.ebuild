# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit autotools eutils

MY_P=${P/pdc/PDC}

DESCRIPTION="A public domain curses library for DOS, OS/2, Win32, X11"
HOMEPAGE="http://pdcurses.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="MIT public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO: add SDL support
IUSE="doc examples nextaw Xaw3d"

RDEPEND="Xaw3d? ( x11-libs/Xaw3d )
	!Xaw3d? (
		nextaw? ( x11-libs/neXtaw )
		!nextaw? ( x11-libs/libXaw )
	)"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	if use nextaw && use Xaw3d ; then
		elog "You have both nextaw and Xaw3d USE-flags set, Xaw3d will be used."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}-configure.patch"

	# Fixing soname problem
	sed -i -e "s/\(\$(LD_RXLIB1)\)/\1 -Wl,-soname,libXcurses.so.${PV%.*}/" \
		x11/Makefile.in || die

	# Fixing absolute symlinks
	sed -i -e 's:\(ln -f -s \)$(libdir)/:\1:' \
		Makefile.in || die

	# Fixing tuidemo path
	sed -i -e 's:\.\.[/\\]demos[/\\]::' \
		demos/tuidemo.c || die

	# If enabled, uses "manext" to create a 160K doc/PDCurses.txt
	if ! use doc ; then
		sed -i -e '/cd doc; $(MAKE)/d' \
			Makefile.in || die
	fi

	# Removing the $(DEMOS) from all target
	if ! use examples ; then
		sed -i -e 's/\(^all:[\t a-zA-Z$()]*\) $(DEMOS)/\1/' \
			x11/Makefile.in || die
	fi

	eautoreconf
}

src_configure() {
	econf \
		$(use_with nextaw) \
		$(use_with Xaw3d xaw3d)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc HISTORY IMPLEMNT README doc/*.txt || die

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins demos/*.[ch] || die

		exeinto /usr/share/doc/${PF}/examples
		cd "${S}/x11" || die
		# Which one is better?
		#doins $(sed -e 's/^DEMOS[ \t]*=\(.*\)/\1/p' -e 'd' Makefile.in)
		doexe $(sed -n -e 's/^DEMOS[ \t]*=\(.*\)/\1/p' Makefile.in) || die
	fi
}
