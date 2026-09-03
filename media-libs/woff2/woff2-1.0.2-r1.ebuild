# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Encode/decode WOFF2 font format"
HOMEPAGE="https://github.com/google/woff2"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="app-arch/brotli"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/woff2-1.0.2-aliasing.patch"
	"${FILESDIR}/woff2-1.0.2-gcc15.patch"
	"${FILESDIR}/woff2-cmake-minimum-ver-3.10.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5
		-DCMAKE_SKIP_RPATH=ON # needed, causes QA warnings otherwise
		-DCANONICAL_PREFIXES=ON #661942
	)
	cmake-utils_src_configure
}
