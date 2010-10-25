# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

CABAL_FEATURES="lib haddock profile"
inherit haskell-cabal

DESCRIPTION="Purely functional interface to basic linear algebra and other numerical computations"
HOMEPAGE="http://code.haskell.org/hmatrix/"
SRC_URI="http://hackage.haskell.org/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-haskell/binary
	dev-haskell/storable-complex
	>=dev-lang/ghc-6.10.4
	virtual/lapack"

DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.6"
