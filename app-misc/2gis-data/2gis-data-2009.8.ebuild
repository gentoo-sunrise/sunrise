# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

DESCRIPTION="Proprietary freeware multimedia map of several Russian and Ukrainian towns (data)"
HOMEPAGE="http://2gis.ru"

LICENSE="2Gis-ru"
SLOT="0"
KEYWORDS="~x86"

DEPEND="app-arch/unzip"
RDEPEND="app-misc/2gis"

# filled in in `my_add_town`
IUSE=""
SRC_URI=""

MY_PV_YEAR=$(get_version_component_range 1)
MY_PV_MON=$(get_version_component_range 2)

my_add_town() {
	local useflag=$1
	local town=$2
	local year=$3
	local mon=$4
	local rev=$(( 12*${MY_PV_YEAR} + ${MY_PV_MON} - 12*${year} - ${mon} ))
	SRC_URI="${SRC_URI} ${useflag}? ( http://download.2gis.ru/arhives/2GISData_${town}-${rev}.orig.zip )"
	IUSE="${IUSE} ${useflag}"
}

my_add_town astr Astrakhan 2005 11
my_add_town barn Barnaul 2005 2
my_add_town biysk Biysk 2008 10
my_add_town chel Chelyabinsk 2007 8
my_add_town ekb Ekaterinburg 2005 12
my_add_town irk Irkutsk 2006 4
my_add_town kaz Kazan 2008 11
my_add_town kem Kemerovo 2005 4
my_add_town kras Krasnoyarsk 2005 8
my_add_town kur Kurgan 2006 3
my_add_town nkuz Novokuznetsk 2005 8
my_add_town nnov N_Novgorod 2008 9
my_add_town nsk Novosibirsk 1998 9
my_add_town nvar Nizhnevartovsk 2006 5
my_add_town odes Odessa 2007 2
my_add_town omsk Omsk 2004 8
my_add_town perm Perm 2007 12
my_add_town sam Samara 2008 7
my_add_town tim Tyumen 2006 11
my_add_town tom Tomsk 2004 12
my_add_town ufa Ufa 2008 3

pkg_setup() {
	check_license "${FILESDIR/files}"/../../licenses/${LICENSE}
}

src_install() {
	insinto /opt/2gis
	# Only required data files were unpacked, so it should be safe to
	# use wildcard.
	doins -r 2gis/3.0/* || die
}
