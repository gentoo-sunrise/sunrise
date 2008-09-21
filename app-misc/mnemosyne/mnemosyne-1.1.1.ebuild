# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="Sophisticated flash-card tool also used for long-term memory research"
HOMEPAGE="http://www.mnemosyne-proj.org/"
SRC_URI="mirror://sourceforge/${PN}-proj/${P}-r1.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="latex"

DEPEND="latex? ( app-text/dvipng )
	dev-python/PyQt
	dev-python/pygame"

src_unpack() {
	distutils_src_unpack

	if ! use latex ; then
	sed -i \
		-e "s/process_latex(latex_command):/process_latex(latex_command):\n    return latex_command/" \
		mnemosyne/core/mnemosyne_core.py || die "sed failed"
	fi
}
