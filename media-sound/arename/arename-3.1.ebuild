# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="Automatic audio file renaming"
HOMEPAGE="http://ft.bewatermyfriend.org/comp/arename.html"
SRC_URI="http://github.com/downloads/ft/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test zsh-completion"

RDEPEND="dev-perl/Audio-FLAC-Header
	dev-perl/MP3-Tag
	dev-perl/Readonly
	dev-perl/ogg-vorbis-header"
DEPEND="test? (
		dev-perl/Test-Exception
		media-libs/flac
		media-sound/alsa-utils
		media-sound/id3v2
		media-sound/lame
		media-sound/vorbis-tools
		virtual/perl-Test-Harness
		${RDEPEND}
	)"
# ^ No mistake here -- RDEPEND becomes DEPEND only when testing.

src_compile() {
	# make would only display a usage statement
	true
}

src_test() {
	# Generate the audio data ourselves as we can't rely on recording from ALSA.
	# The content doesn't matter, thus we just get it from /dev/zero and prepend
	# with wavfile header. The resulting wavfile will be converted into various
	# audio formats, tagged and the tags are what really matters.
	mkdir -p tests/data || die
	echo 'UklGRiQAEABXQVZFZm10IBAAAAABAAIARKwAABCxAgAEABAAZGF0YQAAEAA=' \
		| base64 -d > tests/data/input.wav || die
	dd if=/dev/zero of=tests/data/input.wav oflag=append \
		conv=notrunc bs=1M count=1 || die

	emake prepare-test-data || die
	emake test-all || die
}

src_install() {
	# VENDOR_LIB is set by perl_set_version() in pkg_setup()
	emake install prefix="${D}"/usr libpath="${VENDOR_LIB#/usr/}" || die

	doman arename.1 || die
	dodoc README CHANGES arename.hooks || die
	dohtml arename.html || die

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins _arename || die
	fi
}
