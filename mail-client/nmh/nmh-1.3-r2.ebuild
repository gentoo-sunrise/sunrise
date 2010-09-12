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
IUSE="gdbm"

DEPEND="gdbm? ( sys-libs/gdbm )
	!gdbm? ( sys-libs/db )
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
	[ -z "${PAGER}" ] && export PAGER="/usr/bin/more"

	# strip options from ${PAGER} (quoting not good enough) (Bug #262150)
	PAGER=${PAGER%% *}

	# Redefining libdir to be bindir so the support binaries get installed
	# correctly.  Since no libraries are installed with nmh, this does not
	# pose a problem at this time.
	myconf="--libdir=/usr/bin"

	# Have gdbm use flag actually control which version of db in use
	if use gdbm; then
		myconf="${myconf} --with-ndbmheader=gdbm/ndbm.h --with-ndbm=gdbm_compat"
	else
	   	if has_version ">=sys-libs/db-2"; then
			myconf="${myconf} --with-ndbmheader=db.h --with-ndbm=db"
		else
	   		myconf="${myconf} --with-ndbmheader=db1/ndbm.h --with-ndbm=db1"
		fi
	fi

	# use gentoo-editor to avoid implicit dependencies (Bug #294762)
	EDITOR=/usr/libexec/gentoo-editor

	econf \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--with-editor="${EDITOR}" \
		--with-pager="${PAGER}" \
		--enable-nmh-pop \
		--sysconfdir=/etc/nmh \
		$myconf
}

src_install() {
	emake prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		libdir="${D}"/usr/bin \
		etcdir="${D}"/etc/nmh install || die
	dodoc ChangeLog DATE MACHINES README || die
}
