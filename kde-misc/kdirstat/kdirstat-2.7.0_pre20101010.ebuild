# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit kde4-base

DESCRIPTION="Nice KDE replacement to du command"
HOMEPAGE="http://grumpypenguin.org/"
SRC_URI="http://martin.von-gagern.net/gentoo/${P}.tar.bz2"
# SRC_URI generated from git repository:
# git clone http://grumpypenguin.org/~josh/kdirstat.git
# cd kdirstat
# git archive --prefix kdirstat-2.7.0_pre20101010/ \
#     6c0a9e67421f2f2e1ca3b75d578fdd6afaeceaf6 | \
#     bzip2 > kdirstat-2.7.0_pre20101010.tar.bz2

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=kde-base/libkonq-4.6.4
	>=sys-libs/zlib-1.2.5-r2"
DEPEND="${RDEPEND}"
