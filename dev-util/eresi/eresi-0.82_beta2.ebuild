# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="The ERESI Reverse Engineering Software Interface: elfsh and friends"
HOMEPAGE="http://www.eresi-project.org/"
# Steps to regenerate archive:
#   svn export http://svn.eresi-project.org/svn/trunk@1283 eresi-0.82_beta2
#   tar cvjf eresi-0.82_beta2{.tar.bz2,}
# To find the latest release and the corresponding svn revision:
#   svn annotate \
#   http://svn.eresi-project.org/svn/trunk/librevm/include/revm-io.h \
#   | egrep 'REVM_(RELEASE|VERSION)'
SRC_URI="http://martin.von-gagern.net/gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="readline server doc"

DEPEND="readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}
	!<dev-util/elfsh-0.75"
# dev-util/elfsh-0.75 should be used as a transition package,
# depending on eresi but not installing any files of its own.

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/0.82_beta2-parallel-make.patch
	sed -i \
		-e 's: -O2 : :g' \
		-e "s: -g3 : ${CFLAGS} :" \
		-e "/^LDFLAGS/s:=:=${LDFLAGS} :" \
		$(find -name Makefile) || die
}

src_compile() {
	# non-standard configure script
	# doesn't understand --disable-*, so don't use use_enable
	local conf="--prefix /usr"
	conf="${conf} --enable-32-64"
	conf="${conf} --set-compiler $(tc-getCC)"
	use readline && conf="${conf} --enable-readline"
	use server && conf="${conf} --enable-network"
	echo "./configure ${conf}"
	./configure  ${conf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc doc/{AUTHOR,CREDITS,README.FIRST} || die "dodoc failed"
	if use doc; then
		dodoc doc/{cerberus2,elfsh-network-0.3,elfsh-ref}.txt \
			doc/{graphers,libelfsh-ref,rtld-multiarch}.txt || die "dodoc failed"
		dodoc doc/{Changelog,ERESI.NEWHOOKS,eresirc.example} || die "dodoc failed"
		dodoc doc/{KERNSH.bugs,libelfsh.i} || die "dodoc failed"
	fi
}
