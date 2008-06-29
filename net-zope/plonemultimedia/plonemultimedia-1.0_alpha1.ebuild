# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator zproduct

MY_PV="$(replace_all_version_separators '-' )"
MY_PN="PloneMultimediaBundle"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Products to improve Plone's support for multimedia such as audio, video and photos."
HOMEPAGE="http://plone.org/products/plonemultimedia"
SRC_URI="http://plone.org/products/plonemultimedia/releases/${PV:0:3}/${MY_P}-tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""

DEPEND=">=net-zope/plone-2.1
	>=net-zope/zope-2.8"
RDEPEND="${DEPEND}
	dev-python/mmpython"

S="${WORKDIR}/${MY_PN}"

ZPROD_LIST="ATAudio
	ATMediaFile
	ATPhoto
	ATVideo
	ExternalStorage
	FileSystemStorage
	LinguaPlone
	mod_limewire
	PloneJUpload"

src_unpack() {
	# this has to be done manually since $A is incorrect, and readonly
	# unpack function does not work either
	tar xzf "${DISTDIR}"/${MY_P}-tar.gz -C "${WORKDIR}" || die 'unpack failed'
}

src_install() {
	dodoc README.txt

	# then move the Products into $WORKDIR, and install from there
	for Product in ${ZPROD_LIST}; do
		mv "${Product}" "${WORKDIR}"
	done

	# remove now Productless ${PN}..
	cd "${WORKDIR}"
	rm -rf "${S}"
	S="${WORKDIR}"

	# install Products
	zproduct_src_install all
}

pkg_postinst() {
	elog
	elog "The PloneMultimedia 1.0-alpha1 bundle includes:"
	elog "    * ATAudio 0.6"
	elog "    * ATVideo 1.0-alpha1"
	elog "    * ATPhoto 1.0-alpha1"
	elog "    * ATMediaFile 1.0-alpha1"
	elog "    * PloneJUpload 1.0-alpha2"
	elog "    * ExternalStorage 0.7"
	elog "    * FileSystemStorage"
	elog "    * mod_limewire"
	elog
}
