# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

MY_P=${P/./-}

DESCRIPTION="Open-Source Software Implementation of a DRM-Receiver"
HOMEPAGE="http://drm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="hamlib sndfile"

RDEPEND="media-libs/alsa-lib
	media-libs/faad2[digitalradio]
	net-libs/libpcap
	sci-libs/fftw:2.1
	x11-libs/qwt:0
	hamlib? ( media-libs/hamlib )
	sndfile? ( media-libs/libsndfile )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	# fix configure.in so that it links to libqwt.so.4
	epatch "${FILESDIR}"/drm-qwt4.diff
	epatch "${FILESDIR}"/${PV}-gcc4.4.patch
	eautoreconf
}

# at the moment only ALSA is working
src_configure() {
	econf $(use_enable hamlib) \
		--disable-jack \
		--disable-portaudio \
		--enable-alsa \
		--disable-oss \
		--enable-qt \
		--enable-faad2 \
		--disable-faac \
		--enable-pcap \
		$(use_enable sndfile)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
}
