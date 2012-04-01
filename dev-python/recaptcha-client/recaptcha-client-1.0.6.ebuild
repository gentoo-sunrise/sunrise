# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Provides a CAPTCHA for Python using the reCAPTCHA service"
HOMEPAGE="http://pypi.python.org/pypi/recaptcha-client/"
SRC_URI="mirror://pypi/r/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pycrypto"

DOCS="PKG-INFO recaptcha_client.egg-info/*"
PYTHON_MODNAME=recaptcha
