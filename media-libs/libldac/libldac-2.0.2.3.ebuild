# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="LDAC codec library from AOSP"
HOMEPAGE="https://android.googlesource.com/platform/external/libldac/"
SRC_URI="https://github.com/EHfive/ldacBT/releases/download/v${PV}/ldacBT-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}/ldacBT"

src_configure() {
	local mycmakeargs=(
		-DLDAC_SOFT_FLOAT=OFF
		-DINSTALL_LIBDIR=/usr/$(get_libdir)
	)

	cmake_src_configure
}
