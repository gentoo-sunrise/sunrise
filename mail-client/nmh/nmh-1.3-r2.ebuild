# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="New MH mail reader"
HOMEPAGE="http://www.nongnu.org/nmh/"
SRC_URI="http://savannah.nongnu.org/download/nmh/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( sys-libs/gdbm =sys-libs/db-1.85* )
	>=sys-libs/ncurses-5.2
	net-libs/liblockfile
	app-editors/gentoo-editor
	!!media-gfx/pixie" # Bug #295996 media-gfx/pixie also uses show
RDEPEND="${DEPEND}"


src_prepare() {
	# Patches from bug #22173.
	epatch "${FILESDIR}"/${P}-inc-login.patch
	epatch "${FILESDIR}"/${P}-install.patch
	# bug #57886
	epatch "${FILESDIR}"/${P}-m_getfld.patch
	# bug #319937
	epatch "${FILESDIR}"/${P}-db5.patch
	# Allow parallel compiles/installs
	epatch "${FILESDIR}"/${P}-parallelmake.patch
}

src_configure() {
	[ -z "${EDITOR}" ] && export EDITOR="prompter"
	[ -z "${PAGER}" ] && export PAGER="/usr/bin/more"

	# Redefining libdir to be bindir so the support binaries get installed
	# correctly.  Since no libraries are installed with nmh, this does not
	# pose a problem at this time.

	# strip options from ${PAGER} (quoting not good enough) (Bug #262150)
	PAGER=${PAGER%% *}

	# use gentoo-editor to avoid implicit dependencies (Bug #294762)

	econf \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--with-editor=/usr/libexec/gentoo-editor \
		--with-pager="${PAGER}" \
		--enable-nmh-pop \
		--sysconfdir=/etc/nmh \
		--libdir=/usr/bin
}

src_install() {
	emake prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		libdir="${D}"/usr/bin \
		etcdir="${D}"/etc/nmh install || die
	dodoc ChangeLog DATE MACHINES README || die
}
