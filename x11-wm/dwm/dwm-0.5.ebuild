# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils toolchain-funcs

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="http://www.10kloc.org/dwm/"
SRC_URI="http://10kloc.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="|| ( x11-libs/libX11 virtual/x11 )"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-config_mk.patch"
	epatch "${FILESDIR}/${P}-numlock.patch"
	epatch "${FILESDIR}/${P}-fixfocus.patch"
}

src_compile() {
	for def in FONT BGCOLOR FGCOLOR BORDERCOLOR; do
		dwm_def="DWM_${def}"
		if [ "X${!dwm_def}" != "X" ]; then
			einfo "Using \"${!dwm_def}\" as ${def}"
			sed -i -e "s/^#define ${def}.*$/#define ${def} \"${!dwm_def}\"/" dwm.h
		else
			einfo "Using default ${def}"
		fi
	done

	for def in MODKEY MASTERW NumLockMask; do
		dwm_def="DWM_${def}"
		if [ "X${!dwm_def}" != "X" ]; then
			einfo "Using ${!dwm_def} as ${def}"
			sed -i -e "s/^#define ${def}.*$/#define ${def} ${!dwm_def}/" dwm.h
		else
			einfo "Using default ${def}"
		fi
	done

	if [ "X${DWM_TERM}" != "X" ]; then
		einfo "Using \"${DWM_TERM}\" as term"
		ARG=""
		for i in ${DWM_TERM}; do
			if [ "X${ARG}" != "X" ]; then
				ARG="${ARG}, \"${i}\""
			else
				ARG="\"${i}\""
			fi
		done
		sed -i -e "s/^const char \*term\[\] =.*$/const char \*term\[\] = \{ ${ARG} , NULL \};/" event.c
	else
		einfo "Using default term"
	fi

	if [ "X${DWM_TAGS}" != "X" ]; then
		einfo "Using \"${DWM_TAGS}\" as tags"
		epatch "${FILESDIR}/${P}-tags.patch"
		i=0;
		for tag in ${DWM_TAGS}; do
			sed -i -e "s/GT${i}/T${tag}/" event.c
			TAGS="${TAGS} [T${tag}] = \"${tag}\","
			TAGS_ENUM="${TAGS_ENUM} T${tag},"
			if [ "${tag}" == "${DWM_DEFAULT_TAG}" ]; then
				default_tag=${tag}
			elif [ "X$default_tag" == "X" ]; then
				default_tag=${tag}
			fi
			i=$(($i+1))
		done
		while [ $i -le 9 ]; do
			sed -i -e "s/.*GT${i}.*//" event.c
			i=$(($i+1))
		done
		sed -i -e "s/^enum { };/enum \{ ${TAGS_ENUM} TLast \};/" dwm.h
		sed -i -e "s/^char \*tags\[TLast\] = { };/char \*tags\[TLast\] = \{ ${TAGS} \};/" tag.c
		sed -i -e "s/^int tsel =.*;/int tsel = T${default_tag};/" main.c

		if [ "X${DWM_RULES}" != "X" ]; then
			einfo "Using \"${DWM_RULES}\" as rules"
			sed -i -e "s/^static Rule rule\[\] = { };/static Rule rule\[\] = \{ ${DWM_RULES} \};/" tag.c
		fi
	else
		einfo "Using default tags"
	fi

	if [ "X${DWM_KEYBOARD}" == "Xbe" ]; then
		einfo "Using ${DWM_KEYBOARD} keyboard"
		sed -i -e "s/XK_0/XK_agrave/" \
			-e "s/XK_1/XK_ampersand/" \
			-e "s/XK_2/XK_eacute/" \
			-e "s/XK_3/XK_quotedbl/" \
			-e "s/XK_4/XK_apostrophe/" \
			-e "s/XK_5/XK_parenleft/" \
			-e "s/XK_6/XK_section/" \
			-e "s/XK_7/XK_egrave/" \
			-e "s/XK_8/XK_exclam/" \
			-e "s/XK_9/XK_ccedilla/" event.c
	elif [ "X${DWM_KEYBOARD}" == "Xfr" ]; then
		einfo "Using ${DWM_KEYBOARD} keyboard"
		sed -i -e "s/XK_0/XK_agrave/" \
			-e "s/XK_1/XK_ampersand/" \
			-e "s/XK_2/XK_eacute/" \
			-e "s/XK_3/XK_quotedbl/" \
			-e "s/XK_4/XK_apostrophe/" \
			-e "s/XK_5/XK_parenleft/" \
			-e "s/XK_6/XK_less/" \
			-e "s/XK_7/XK_egrave/" \
			-e "s/XK_8/XK_underscore/" \
			-e "s/XK_9/XK_ccedilla/" event.c
	else
		einfo "Using default keyboard"
	fi

	emake CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"
}

pkg_postinst() {
	einfo "To customize dwm set this variables by examples:"
	einfo "DWM_FONT=\"-*-terminus-medium-*-*-*-13-*-*-*-*-*-iso10646-*\""
	einfo "DWM_BGCOLOR=\"#0a2c2d\""
	einfo "DWM_FGCOLOR=\"#ddeeee\""
	einfo "DWM_BORDERCOLOR=\"#176164\""
	einfo "DWM_MODKEY=\"Mod1Mask\""
	einfo "DWM_MASTERW=\"52\""
	einfo "DWM_NumLockMask=\"Mod2Mask\""
	einfo "DWM_TERM=\"xterm\""
	einfo "DWM_TAGS=\"fnord dev net work misc\""
	einfo "DWM_RULES='{ \\\"Firefox.*\\\", { [Tnet] = \\\"net\\\" }, False }, { \\\"Gimp.*\\\", { 0 }, True},'"
	einfo "DWM_DEFAULT_TAG=\"dev\""
	einfo "DWM_KEYBOARD=\"en\""
}
