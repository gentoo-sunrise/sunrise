# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit vcs-snapshot latex-package

ACROREAD_LICENSE="Adobe"
ACROREAD_PV="9.5.1"
ACROREAD_F="AdbeRdr${ACROREAD_PV}-1_i486linux_enu"
ACROREAD_URI="http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/${ACROREAD_PV}/enu/${ACROREAD_F}.tar.bz2"

GIT_REV="0a71f88df83962518ba16a6111743522642c9fba"

DESCRIPTION="LaTeX support for Adobe's Pro opentype fonts Minion Pro, Myriad Pro, Cronos Pro and possibly more"
HOMEPAGE="https://github.com/sebschub/FontPro"
SRC_URI="https://github.com/sebschub/FontPro/archive/${GIT_REV}.tar.gz -> ${P}.tar.gz
	${ACROREAD_URI}"

LICENSE="public-domain ${ACROREAD_LICENSE}"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +minionpro +myriadpro"
REQUIRED_USE="|| ( minionpro myriadpro )"
RESTRICT="mirror bindist"

# dev-texlive/texlive-genericextra contains fltpoint.sty
DEPEND="app-text/lcdf-typetools
	app-text/texlive-core
	dev-tex/fontaxes
	dev-texlive/texlive-genericextra
	minionpro? ( dev-tex/mnsymbol )
	myriadpro? ( dev-tex/mdsymbol )
	!dev-tex/MyriadPro
	!dev-tex/MinionPro"
RDEPEND="${DEPEND}"

src_unpack() {
	vcs-snapshot_src_unpack

	tar -xf "${WORKDIR}/${ACROREAD_F}/COMMON.TAR" Adobe/Reader9/Resource/Font \
		|| die "Failed to unpack COMMON.TAR."
}

prepare_font() {
	einfo "Preparing ${1}..."

	local my_s
	my_s=${WORKDIR}/${1}
	cp -r "${S}" "${my_s}" || die "cp failed"

	# Copy otf files from Adobe Reader
	mkdir "${my_s}/otf" || die "mkdir failed"
	find "${WORKDIR}/Adobe/Reader9/Resource/Font/" -name "${1}*.otf" \
		-exec cp '{}' "${my_s}/otf" ';' || die "cp failed"
}

src_prepare() {
	use minionpro && prepare_font MinionPro
	use myriadpro && prepare_font MyriadPro
}

compile_font() {
	einfo "Compiling ${1}..."

	local my_s
	my_s=${WORKDIR}/${1}
	cd "${my_s}" || die "cd failed"

	./scripts/makeall ${1} || die "makeall failed"
}

src_compile() {
	use minionpro && compile_font MinionPro
	use myriadpro && compile_font MyriadPro
}

install_font() {
	einfo "Installing ${1}..."

	local my_s
	my_s=${WORKDIR}/${1}
	cd "${my_s}" || die "cd failed"

	./scripts/install "${D}/${TEXMF}" || die "install failed"

	# Prevent overwriting the already installed ls-R file on merge
	rm "${D}/${TEXMF}/ls-R" || die "rm failed"

	if use doc; then
		# Inspired by latex-package.eclass
		insinto "/usr/share/doc/${PF}"
		doins "${SS}/tex/${1}.pdf"
		dosym "/usr/share/doc/${PF}/${1}.pdf" "${TEXMF}/doc/latex/${1}/${1}.pdf"
	fi
}

src_install() {
	if use minionpro; then
		install_font MinionPro
		echo "MixedMap MinionPro.map" >> "${T}/${PN}.cfg"
	fi

	if use myriadpro; then
		install_font MyriadPro
		echo "MixedMap MyriadPro.map" >> "${T}/${PN}.cfg"
	fi

	insinto /etc/texmf/updmap.d
	doins "${T}/${PN}.cfg"
}

pkg_postinst() {
	latex-package_pkg_postinst

	use minionpro && elog "To use MinionPro, put \\usepackage{MinionPro} in the preamble of your LaTeX document."
	use myriadpro && elog "To use MyriadPro, put \\usepackage{MyriadPro} in the preamble of your LaTeX document."
}
