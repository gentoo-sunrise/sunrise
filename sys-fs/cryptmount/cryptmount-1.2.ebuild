# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic linux-info

DESCRIPTION="A utility for management and user-mode mounting of encrypted filesystems"
HOMEPAGE="http://cryptmount.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls ssl"

DEPEND="sys-fs/device-mapper
	>=dev-libs/libgcrypt-1.1.94
	ssl? ( dev-libs/openssl )
	nls? ( sys-devel/gettext )"
RDEPEND="${DEPEND}"
CONFIG_CHECK="BLK_DEV_DM"
ERROR_BLK_DEV_DM="Please enable Device mapper support in your kernel config
	-> Device Drivers
		-> Multi-device support (RAID and LVM)
			-> Multiple devices driver support (RAID and LVM) (MD)
				<M> Device mapper support"

src_compile() {
	# recommended for setXid, dynamically linked biraries
	append-ldflags -Wl,-z,now

	econf \
		--with-gnu-ld \
		--with-libgcrypt \
		$(use_enable nls) \
		$(use_with ssl openssl) \
	|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc ABOUT-NLS AUTHORS ChangeLog NEWS README RELNOTES ToDo
}
