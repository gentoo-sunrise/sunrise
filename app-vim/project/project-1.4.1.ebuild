# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit vim-plugin

DESCRIPTION="vim plugin: Managing multiple projects with multiple sources"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=69"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=6273
	-> ${P}.tar.gz"
LICENSE="as-is"
KEYWORDS="~ppc"
IUSE=""

S=${WORKDIR}

VIM_PLUGIN_HELPFILES="project"
