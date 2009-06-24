# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="An Open Source implementation of the OpenMAX Integration Layer"
HOMEPAGE="http://omxil.sourceforge.net"
SRC_URI="mirror://sourceforge/omxil/libomxil-${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa doc fbcon ffmpeg jpeg mad vorbis"

RDEPEND="media-libs/alsa-lib
         mad? ( media-libs/libmad )
         vorbis? ( media-libs/libvorbis )
         ffmpeg? ( media-video/ffmpeg )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/libomxil-${P}"

src_compile() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_enable alsa) \
		$(use_enable doc) \
		$(use_enable fbcon fbvideosink) \
		$(use_enable ffmpeg ffmpegcomponents) \
		$(use_enable jpeg) \
		$(use_enable mad madcomponents) \
		$(use_enable vorbis vorbiscomponents)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog || die "dodoc failed"
}
