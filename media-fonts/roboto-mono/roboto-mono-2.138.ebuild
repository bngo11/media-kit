# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit font

DESCRIPTION="Standard font for Android 4.0 (Ice Cream Sandwich) and later"
HOMEPAGE="https://fontlibrary.org/en/font/roboto-mono"
SRC_URI="https://fontlibrary.org/assets/downloads/roboto-mono/fa85404374f790dace3a23ea31a1c175/roboto-mono.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

DEPEND="app-arch/unzip"

S=${WORKDIR}
FONT_S=${S}

FONT_SUFFIX="ttf"
FONT_CONF=( "${FILESDIR}"/90-roboto-mono.conf )
