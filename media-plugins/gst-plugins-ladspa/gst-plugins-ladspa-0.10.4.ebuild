# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-ladspa/gst-plugins-ladspa-0.10.4.ebuild,v 1.1 2007/02/16 12:09:27 lack Exp $

inherit gst-plugins-bad

KEYWORDS="~amd64 ~x86"

RDEPEND=">=media-libs/ladspa-sdk-1.12-r2
		>=media-libs/gst-plugins-base-0.10.10.1
			>=media-libs/gstreamer-0.10.10"

DEPEND="${RDEPEND}"