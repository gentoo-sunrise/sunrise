# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="*:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"
PYTHON_MODNAME="libmimms libradiotv"

inherit distutils bzr

DESCRIPTION="A PyGTK tv/radio streaming channel archive"
HOMEPAGE="https://launchpad.net/tv-player"
SRC_URI=""
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

EBZR_REPO_URI="lp:tv-player"

DEPEND="dev-python/pygtk
	media-video/flvstreamer
	media-libs/libmms
	media-libs/gst-plugins-base
	media-libs/gst-plugins-good
	media-libs/gst-plugins-ugly
	dev-python/gst-python"
RDEPEND="${DEPEND}"
