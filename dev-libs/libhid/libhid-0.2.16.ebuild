# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Provides a generic and flexible way to access and interact with
USB HID devices"
HOMEPAGE="http://libhid.alioth.debian.org/"
SRC_URI="http://beta.magicaltux.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug doc python"

RDEPEND="dev-libs/libusb"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	python? ( dev-lang/swig >=dev-lang/python-2.1.0 )"

src_compile() {
	local myconf

	myconf="$(use_with doc doxygen) $(use_enable debug)"

	if use python; then
		# libhid includes its own python detection m4 from
		# http://autoconf-archive.cryp.to/ac_python_devel.html
		# As it seems to detect python in the wrong place, we'll force it by
		# passing the right environnement variables, only if we have the python
		# flag
		PYTHON_LDFLAGS="$(python-config --ldflags)" \
			econf --enable-swig ${myconf}
	else
		# avoid libhid running swig if it finds it automatically as long as the
		# "python" use flag is not set
		econf --disable-swig ${myconf}
	fi

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	dodoc AUTHORS ChangeLog NEWS README README.licence TODO || die
	if use doc; then
		dohtml -r doc/html/*
	fi
}

