# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PV=${PV/_beta/beta}
MY_P="$PN-${MY_PV}"

DESCRIPTION="A package with many different plugins for gaim"
HOMEPAGE="http://gaim.guifications.org"
SRC_URI="http://downloads.guifications.org/gaim-plugins/Plugin%20Pack/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
PLUGINS="autorejoin awaynotify bashorg bit blistops dice difftopic eight_ball
flip gRIM groupmsg irssi lastseen listhandler mystatusbox nicksaid oldlogger
plonkers sepandtab showoffline simfix slashexec sslinfo talkfilters xchat-chats"
IUSE="${PLUGINS} debug"

DEPEND="~net-im/gaim-2.0.0_beta6
	talkfilters? ( app-text/talkfilters )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_compile() {
	einfo "The plugins that are to be built are configured via use flags."
	einfo "If none of the optional use flags is set _ALL_ plugins are built,"
	einfo "so adjusting /etc/portage/package.use might be a good idea before merging."

	# XMMS Remote is disabled due to XMMS being masked
	#
	# Disabled due to non-working status:
	# Gaim Schedule (http://gaim.guifications.org/trac/wiki/GaimSchedule)
	# buddytime
	# chronic
	# Stocker (http://gaim.guifications.org/trac/wiki/stocker)
	#
	# Disabled due to being included in current gaim release:
	# Auto Accept
	# Auto Reply
	# Buddy Note
	# convcolors
	# Marker Line
	# New Line
	# Offline Message

	local myconf=""
	local plugins=${PLUGINS/bashorg/bash}
	local myplugins=""

	for plugin in ${plugins} ; do
		use ${plugin} && myplugins="${myplugins}${plugin},"
	done
	if [ ! -z ${myplugins} ] ; then
		myconf="--with-plugins=${myplugins}"
	else
		myconf="--with-plugins=${plugins}"
	fi

	econf "${myconf}" $(use_enable debug) || die "econf failed with ${myconf}"
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO VERSION
}
