# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CABAL_FEATURES="lib profile haddock"
inherit haskell-cabal

MY_PN=ConfigFile
MY_P=${MY_PN}-${PV}

DESCRIPTION="Parser and writer for handling sectioned config files in Haskell"
HOMEPAGE="https://github.com/jgoerzen/configfile/wiki"
SRC_URI="http://hackage.haskell.org/packages/archive/${MY_PN}/${PV}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/missingh-1.0.0.0
	<dev-haskell/mtl-2.0.0.0
	>=dev-lang/ghc-6.12.0"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6"

S=${WORKDIR}/${MY_P}
