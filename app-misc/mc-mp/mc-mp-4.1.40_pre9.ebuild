# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils pam

MY_PN="mc"
MY_P="${MY_PN}-${PV/_/-}"

DESCRIPTION="GNU Midnight Commander cli-based file manager. 4.1.x branch"
HOMEPAGE="http://mc.linuxinside.com/cgi-bin/dir.cgi"
SRC_URI="http://mc.linuxinside.com/Releases/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="7zip gpm nls ncurses pam slang"

PROVIDE="virtual/editor"

RDEPEND="kernel_linux? ( >=sys-fs/e2fsprogs-1.19 )
	ncurses? ( >=sys-libs/ncurses-5.2-r5 )
	pam? ( >=sys-libs/pam-0.78-r3 net-nds/portmap )
	gpm? ( >=sys-libs/gpm-1.19.3 )
	slang? ( >=sys-libs/slang-1.4.2 )
	x86? ( 7zip? ( >=app-arch/p7zip-4.16 ) )
	amd64? ( 7zip? ( >=app-arch/p7zip-4.16 ) )
	!app-misc/mc"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	if ( use x86 || use amd64 ) && use 7zip; then
		epatch "${FILESDIR}/${PV}/u7z.patch"
	fi

	epatch "${FILESDIR}/${PV}/ebuild-syntax.patch"
	epatch "${FILESDIR}/${PV}/mc-menu.patch"
	epatch "${FILESDIR}/${PV}/gcc34.patch"

	# Prevent lazy bindings in cons.saver binary. (bug #135009)
	# Also prevent stripping the binary, portage takes care of this as needed
	#  - not using bindnow-flags() because cons.saver is only built on GNU/Linux
	sed -i -e "s:(CC) -s cons.saver.o:(CC) -Wl,-z,now cons.saver.o:" \
		src/Makefile.in || die "sed failed in Makefile.in"
}

src_compile() {
	filter-flags -malign-double

	local myconf=""

	if ! use slang && ! use ncurses ; then
		myconf="${myconf}"
	elif
		use ncurses && ! use slang ; then
			myconf="${myconf} --with-ncurses --without-included-slang"
	else
		use slang && myconf="${myconf} --with-included-slang --with-terminfo --with-slang"
	fi

	myconf="${myconf} `use_with gpm gpm-mouse`"

	use nls \
		&& myconf="${myconf} --with-included-gettext" \
		|| myconf="${myconf} --disable-nls"

	# X support not ready yet
	# myconf="${myconf} `use_with X x`"

	econf \
	--with-vfs \
	--with-ext2undel \
	--with-edit \
	--enable-charset \
	--with-mcfs \
	--with-subshell \
	--with-netrc \
	--with-dusum \
	${myconf} || die

	emake || die
}

src_install() {
	cat "${FILESDIR}/chdir.gentoo" > "${S}/lib/mc.sh"
	rm -f "${S}/README."{NT,OS2,QNX}

	einstall || die

	# install cons.saver setuid, to actually work
	chmod u+s "${D}/usr/lib/mc/bin/cons.saver"

	use pam && newpamd "${FILESDIR}/mcserv.pamd" mcserv
	use pam && newinitd "${FILESDIR}/mcserv.rc" mcserv

	exeinto /usr/lib/mc/bin
	doexe "${S}/lib/mc.sh"
	doexe "${S}/lib/mc.csh"

	insinto /usr/lib/mc
	doins "${FILESDIR}/mc."{gentoo,ini}

	insinto /usr/lib/mc/syntax
	doins "${FILESDIR}/ebuild.syntax"

	rm -rf "${D}/usr/man" "${D}/usr/share/man"
	doman "${S}/doc/"*.{1,8}
	dodoc FAQ NEWS README.*
}

pkg_postinst() {
	elog "Add the following line to your ~/.bashrc to"
	elog "allow mc to chdir to its latest working dir at exit"
	elog
	elog "# Midnight Commander chdir enhancement"
	elog "if [ -f /usr/lib/mc/mc.gentoo ]; then"
	elog ". /usr/lib/mc/mc.gentoo"
	elog "fi"
}
