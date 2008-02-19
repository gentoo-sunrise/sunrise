# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

MY_P=SCMBUG_RELEASE_$(replace_all_version_separators -)

DESCRIPTION="integrates verion control system with bug trackers"
HOMEPAGE="http://www.mkgnu.net/?q=scmbug"
SRC_URI="http://files.mkgnu.net/files/scmbug/${MY_P}/source/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="doc? ( media-gfx/transfig )"
RDEPEND="dev-perl/Mail-Sendmail"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Remove threads dependency which crashes SCMBUG at startup
	# and use fork instead
	epatch "${FILESDIR}/${P}-threads.patch"
}

src_compile() {
	econf $(use_with doc)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
