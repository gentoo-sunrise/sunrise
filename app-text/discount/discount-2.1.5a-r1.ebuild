# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="An implementation of John Gruber's Markdown text to html language written in C"
HOMEPAGE="http://www.pell.portland.or.us/~orc/Code/discount/"
SRC_URI="http://www.pell.portland.or.us/~orc/Code/${PN}/${P}.tar.bz2"

LICENSE="DLPARSONS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

src_prepare() {
	# for QA, we remove the Makefiles usage of install -s
	sed -e '/INSTALL_PROGRAM/s#-s ##' -i configure.inc \
	|| die "sed can't fix stripping of files"
}

src_configure() {
	local myconf
	use minimal || myconf="--enable-all-features"

	./configure.sh "${myconf}" \
	--prefix=/usr \
	--mandir=/usr/share/man \
	|| die
}

src_install() {
	local myinstall
	use minimal && myinstall="install" || myinstall="install.everything"
	emake DESTDIR="${D}" ${myinstall}
}
