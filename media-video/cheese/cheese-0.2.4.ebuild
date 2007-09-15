# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gnome2

DESCRIPTION="A cheesy program to take pictures and videos from your webcam"
HOMEPAGE="http://live.gnome.org/Cheese"

SRC_URI="http://live.gnome.org/Cheese/Releases?action=AttachFile&do=get&target=${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

LANGS="cs da de es fr gl it ja nl pl pt"
for x in ${LANGS} ; do
	IUSE="${IUSE} linguas_${x}"
done

RDEPEND="dev-libs/dbus-glib
	>=dev-libs/glib-2.12
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libglade-2.0.0
	>=gnome-base/libgnomeui-2
	>=gnome-extra/evolution-data-server-1.10
	>=media-libs/gstreamer-0.10.12
	>=media-libs/gst-plugins-base-0.10.12
	>=media-plugins/gst-plugins-gconf-0.10
	>=media-plugins/gst-plugins-ogg-0.10
	>=media-plugins/gst-plugins-pango-0.10.12
	>=media-plugins/gst-plugins-theora-0.10
	>=media-plugins/gst-plugins-v4l-0.10
	>=media-plugins/gst-plugins-v4l2-0.10
	>=media-plugins/gst-plugins-vorbis-0.10
	>=sys-apps/dbus-1
	x11-libs/cairo
	>=x11-libs/gtk+-2.10
	x11-libs/libXxf86vm"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

DOCS="AUTHORS ChangeLog README TODO"

src_unpack() {
	gnome2_src_unpack
	if ! use nls ; then
		sed -i -e "s/src po data/src data/" Makefile || die "sed failed"
	else
		for x in ${LANGS} ; do
			use linguas_${x} || sed -i -e "/^LANGS/s:${x}::" po/Makefile || die "sed failed"
		done
	fi
}
