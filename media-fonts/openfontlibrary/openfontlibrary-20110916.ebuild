# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils font

# Structure of this variable:
# - in each line, encode one font from OpenFontLibrary
# - fields are separated by |
# - fields are as follows:
#   - use flagg (see IUSE below)
#   - download url (from OpenFontLibrary's page for font)
#   - pattern which files to be installed
#     (.otf files are preferred over .ttf)
#   - license (Open Font License in most cases,
#     see OpenFontLibrary's page for font)
FONTLIST="handwriting|http://openfontlibrary.org/assets/downloads/graziano/493b3e1535054a8f076d02ba9f945ad1/graziano.zip|Graziano.ttf|OFL
          handwriting|http://openfontlibrary.org/assets/downloads/intuitive/71763f72bef454e1fc6ac6ddc2fd8e7f/intuitive.zip|intuitive.ttf|OFL
          sansserif|http://openfontlibrary.org/assets/downloads/douar-outline/08717079a1f176808971879f24d44f39/douar-outline.zip|DouarOutline.ttf|OFL
          sansserif|http://openfontlibrary.org/assets/downloads/junction/f99fa7793abd572cc4e202f8cafa1a28/junction.zip|junction_OFL/Junction*.otf|OFL
          sansserif|http://openfontlibrary.org/assets/downloads/alfphabet/55201027210b27c9c647eb66918f3abe/alfphabet.zip|OSP_Alfphabet/Alfphabet-IV.ttf|OFL
          sansserif|http://openfontlibrary.org/assets/downloads/osp-din/fa3d08bd4b819d71da421ae73c1bd1d1/osp-din.zip|OSP-foundry_DIN/OSP-DIN.ttf|OFL
          sansserif|http://openfontlibrary.org/assets/downloads/freeuniversal/5077bdf47767ac210dd15ea83870df66/freeuniversal.zip|FreeUniversal-*.ttf|OFL
          sansserif|http://openfontlibrary.org/assets/downloads/vds/e04696b834661151239f2123b9ca9ef9/vds.zip|TTF/VDS*.ttf|OFL
          sansserif|http://openfontlibrary.org/assets/downloads/pfennig/bfe495172cefc2388a81ee630281d8e5/pfennig.zip|Pfennig*.ttf|OFL
          sansserif|http://openfontlibrary.org/assets/downloads/jura/514421954ac740cb72effbd2aa7c477e/jura.zip|Jura-*.ttf|OFL
          sansserif|http://openfontlibrary.org/assets/downloads/didact-gothic/e12a3678deb5791ac79cf0e3f0569663/didact-gothic.zip|DidactGothic.ttf|OFL
          sansserif|http://openfontlibrary.org/assets/downloads/sansus-webissimo/9e7ef959f7aeef22383039a04e56def9/sansus-webissimo.zip|Sansus*.otf|CCPL-Attribution-3.0
          sansserif|http://openfontlibrary.org/assets/downloads/designosaur/20b76920b181bc400c45166473687ed6/designosaur.zip|OT-ps/Designosaur-*.otf|CCPL-Attribution-3.0
          sansserif|http://openfontlibrary.org/assets/downloads/klaudia-and-berenika/0a3b87bd1a161792058e644854ee7b9b/klaudia-and-berenika.zip|Klaudia*/*/*.ttf|OFL
          monospaced|http://openfontlibrary.org/assets/downloads/notcouriersans/283f31e5facea102ba05ffe4d60b340f/notcouriersans.zip|OSP_NotCourierSans/NotCourierSans*.otf|OFL
          serif|http://openfontlibrary.org/assets/downloads/squareantiqua/9e7334002d839460e2d6cb7fe9f217b0/squareantiqua.zip|*Antiqua/SquareAntiqua*.ttf|OFL
          serif|http://openfontlibrary.org/assets/downloads/old-standard/8f7616da5d24d2c54ec2d8e734320ac1/old-standard.zip|oldstandard-2.0.2.otf/OldStandard-*.otf|OFL
          serif|http://openfontlibrary.org/assets/downloads/open-baskerville/7d908608fdbf11a2f990dee983c3ef35/open-baskerville.zip|OpenBaskerville-*/OpenBaskerville-*.otf|OFL
          serif|http://openfontlibrary.org/assets/downloads/libertinage/7e850a8dd5040bf3070dc8a720604844/libertinage.zip|OSP_Libertinage/Libertinage*.ttf|OFL
          serif|http://openfontlibrary.org/assets/downloads/acknowledgement/a5294ce75f3058111216b845e2bd2a6d/acknowledgement.zip|distribution/rendered/Acknowledgement.otf|OFL
          serif|http://openfontlibrary.org/assets/downloads/judson/51d83ce369280539578dd360d378d814/judson.zip|Judson-*.ttf|OFL
          serif|http://openfontlibrary.org/assets/downloads/crimson/6feb6f6187adb04e0ea4a40f69101d98/crimson.zip|Crimson-*.otf|OFL"

function get_font_src_uri {
	for line in ${FONTLIST} ; do
		read use url pattern license <<<${line//|/ }
		echo "${use}? ( ${url} )"
	done
}

function get_font_license {
	for line in ${FONTLIST} ; do
		read use url pattern license <<<${line//|/ }
		echo "${use}? ( $license )"
	done | sort -u
}

function get_font_filepattern {
	for line in ${FONTLIST} ; do
		read use url pattern license <<<${line//|/ }
		if use $use ; then echo "$pattern" ; fi
	done
}

DESCRIPTION="Fonts that come with the freedom to use, study, share and remix"
HOMEPAGE="http://openfontlibrary.org/"

SRC_URI=$(get_font_src_uri)
LICENSE=$(get_font_license)

SLOT="0"
KEYWORDS="~x86"

IUSE="handwriting +monospaced +sansserif +serif"

S="${WORKDIR}"

src_install() {
	# where to install font files
	insinto /usr/share/fonts/openfontlibrary

	# install all font files as listed in the pattern list
	doins $(get_font_filepattern)

	font_xfont_config
	font_fontconfig
}
