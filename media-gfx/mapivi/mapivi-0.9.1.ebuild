# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${PN}091"
DESCRIPTION="Open-source and cross-platform (UNIX, Mac OS X and Windows) picture manager / organizer written in Perl/Tk"
HOMEPAGE="http://mapivi.sourceforge.net/mapivi.shtml"
SRC_URI="mirror://sourceforge/mapivi/${MY_P}.tgz"

S=${WORKDIR}/${MY_P}

IUSE=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

DEPEND="dev-lang/perl
	>=dev-perl/perl-tk-804.025
	dev-perl/ImageInfo
	media-gfx/jhead
	media-gfx/imagemagick
	media-libs/jpeg
	dev-perl/Image-MetaData-JPEG"

src_install() {
	into ${ROOT}/usr/bin
	dobin mapivi

	into ${ROOT}/usr/share/mapivi/plugins
	dobin PlugIns/Channel-Separator PlugIns/Join-RGB PlugIns/checkDir-plugin\
			PlugIns/filelist-plugin PlugIns/test-plugin
	dodoc Changes.txt FAQ README Tips.txt
	sed -i 's:$configdir\/PlugIns:\/usr\/share\/mapivi\/plugins:g' mapivi
}

pkg_postinst() {
	ewarn "If your Gimp version is 2.3 from CVS you should run:"
	ewarn "sed -i 's:gimp-remote -n  :gimp-remote:g' /usr/bin/mapivi"
	ewarn "sed -i '22732,22734s:^.:\#:g' /usr/bin/mapivi"
	ewarn "sed -i '22735s:\#execute:execute:g' /usr/bin/mapivi"
	ewarn "after instalation to have edit in Gimp option work."
}
