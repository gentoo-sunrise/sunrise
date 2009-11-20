# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools distutils flag-o-matic multilib python

MY_P=${P/00/00.r1714}

DESCRIPTION="Weak Signal Propagation Reporter"
HOMEPAGE="http://www.physics.princeton.edu/pulsar/K1JT/wspr.html"
SRC_URI="http://www.physics.princeton.edu/pulsar/K1JT/${MY_P}.tgz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/python[tk]
	dev-python/numpy
	dev-python/imaging[tk]
	dev-python/pmw
	sci-libs/fftw:3.0
	media-libs/hamlib
	media-libs/portaudio
	media-libs/libsamplerate"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	python_version

	# upstream confused LIBDIRS with LDFLAGS in Makefile. f2py wants only
	# LIBDIRS as parameter and takes LDFLAGS only from environment.
	sed -i \
		-e "s/@LDFLAGS@/@LIBDIRS@/" \
		-e "s/LDFLAGS/LIBDIRS/g" \
		Makefile.in || die "sed failed"

	# drop hardcoded libdir path, 
	# switch LDFLAGS naming to LIBDIRS (see above comment).
	sed -i -e "s/, f2py/, f2py${PYVER}/" \
		-e "s:-L/usr/local/lib:-L/usr/$(get_libdir):" \
		-e "s/LDFLAGS/LIBDIRS/g" \
		configure.ac || die "sed failed"
	eautoreconf
}

src_compile() {
	# -shared is neded by f2py but cannot be set earlier as configure does
	# not like it
	append-ldflags -shared
	emake || die "emake failed."
}

src_install() {
	rm -rf build || die "removing build directory failed"
	distutils_src_install
	dobin wspr || die "dobin failed"
	dodoc BUGS WSPR_*.TXT || die "dodoc failed"
	insinto /usr/share/${PN}
	doins hamlib_rig_numbers || die "doins failed"
}
