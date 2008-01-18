# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator games

MY_PV=$(delete_all_version_separators)

DESCRIPTION="Unreal-themed single-player campaign"
HOMEPAGE="http://www.planetunreal.com/teamvortex/help/"
SRC_URI="ftp://ftp.planetmirror.com/pub/moddb/2005/07/1263-ONP${MY_PV}_Umod.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="|| (
		>=games-fps/unreal-tournament-436
		>=games-fps/unreal-tournament-goty-436 )"
DEPEND="games-util/umodpack
	app-arch/unzip"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/unreal-tournament
docdir=op-napali

src_unpack() {
	local f lcn n

	unpack ${A}
	for f in *.umod ; do
		umod -x "${f}" || die "umod ${f} failed"
	done
	rm *.umod

	cd "${S}"
	unpack ./*.zip
	rm *.{txt,zip}

	mv -f *.unr Maps
	mv -f *.u System

	# Fix filenames in HTML
	sed -i data/docs/*.html \
		-e "s:\.JPG:\.jpg:" \
		-e "s:\.PNG:\.png:" \
		-e "s:TVshortie:tvshortie:" \
		|| die "sed docs failed"

	sed -i *.html \
		-e "s:data/docs:${docdir}/docs:" \
		|| die "sed help doc failed"

	for n in Skaarj Nali Mercenary Krall Brute ; do
		lcn=$(echo "${n}" | tr [:upper:] [:lower:])
		sed -i data/docs/*.html \
			-e "s:${n}\.jpg:${lcn}\.jpg:" \
			|| die "sed ${n} failed"
	done

	# Remove Gamespy ads
	sed -i data/docs/faq.html \
		-e '9,12d' \
		|| die "sed faq failed"

	mv "Operation NaPali Help Doc.html" "${docdir}.html"
	mv data "${docdir}"
}

src_install() {
	insinto "${dir}"
	doins -r * || die "doins -r failed"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	einfo "For instructions and story, read:"
	einfo "${dir}/${docdir}.html"
	echo
}
