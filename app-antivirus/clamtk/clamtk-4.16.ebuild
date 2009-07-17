# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils perl-module

DESCRIPTION="A frontend for ClamAV using Gtk2-perl"
HOMEPAGE="http://clamtk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LANGS="ar cs da de el en_GB es fr gl hr it ja ko ms nl nn pl pt_BR ro ru sk sl sv tr zh_CN"
IUSE="nls"
for i in ${LANGS}; do
	IUSE="${IUSE} linguas_${i}"
done

DEPEND=""
RDEPEND=">=dev-perl/gtk2-perl-1.140
	dev-perl/File-Find-Rule
	dev-perl/libwww-perl
	dev-perl/Net-DNS
	dev-perl/Date-Calc
	dev-perl/Config-Tiny
	dev-util/desktop-file-utils
	>=app-antivirus/clamav-0.90
	nls? ( dev-perl/Locale-gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	perlinfo
	sed -i -e "s:'/usr/lib':'${VENDOR_LIB}':"  clamtk \
		|| die "sed failed"
	gunzip clamtk.1.gz || die "gunzip failed"
}

src_install() {
	dobin clamtk || die

	doicon clamtk.png
	domenu clamtk.desktop

	dodoc CHANGES README || die
	doman clamtk.1 || die

	# The custom Perl modules
	perlinfo
	insinto ${VENDOR_LIB}/ClamTk
	doins lib/*.pm || die

	if use nls ; then
		domo po/*.mo || die
	fi
}
