# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="a series of bash scripts which add a quilt-like interface to git"
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/jsipek/guilt/"
SRC_URI="mirror://kernel/linux/kernel/people/jsipek/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="doc"

DEPEND="app-text/asciidoc
	app-text/xmlto"
RDEPEND="dev-util/git"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e 's/`git-describe`'"/${PV}/" \
		Documentation/Makefile
}

src_compile() {
	cd Documentation

	# generate manuals default
	emake man || die "Generating manuals failed"

	if use doc; then
		emake html || die "Generating html docs failed"
	fi
}

src_install() {
	emake install PREFIX="${D}/usr" || die "Install failed"

	cd Documentation

	# process all doc, default install all manuals
	emake install PREFIX="${D}/usr/share" || die "Install doc failed"

	dodoc HOWTO Contributing Requirements Features

	if use doc; then
		dodir "/usr/share/doc/${PF}/html"
		emake install-html htmldir="${D}/usr/share/doc/${PF}/html" || die "Install doc failed"
	fi
}
