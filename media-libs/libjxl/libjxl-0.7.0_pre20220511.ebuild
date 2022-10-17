# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl"

SRC_URI="https://api.github.com/repos/libjxl/libjxl/tarball/105bf1a20be35c2d0d7dd302c008f3669c2f998c -> ${P}.tar.gz"
KEYWORDS="*"

LICENSE="BSD"
SLOT="0"
IUSE="openexr"

DEPEND="app-arch/brotli:=
	dev-cpp/gflags:=
	>=dev-cpp/highway-0.16.0
	media-libs/giflib:=
	>=media-libs/lcms-2.13:=
	media-libs/libpng:=
	sys-libs/zlib
	media-libs/libjpeg-turbo
	>=x11-misc/shared-mime-info-2.2
	openexr? ( media-libs/openexr:= )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/libjxl-libjxl-105bf1a"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DJPEGXL_ENABLE_BENCHMARK=OFF
		-DJPEGXL_ENABLE_COVERAGE=OFF
		-DJPEGXL_ENABLE_FUZZERS=OFF
		-DJPEGXL_ENABLE_SJPEG=OFF
		-DJPEGXL_WARNINGS_AS_ERRORS=OFF

		-DJPEGXL_ENABLE_SKCMS=OFF
		-DJPEGXL_ENABLE_VIEWERS=OFF
		-DJPEGXL_ENABLE_PLUGINS=OFF
		-DJPEGXL_FORCE_SYSTEM_BROTLI=ON
		-DJPEGXL_FORCE_SYSTEM_HWY=ON
		-DJPEGXL_FORCE_SYSTEM_LCMS2=ON
		-DJPEGXL_ENABLE_DOXYGEN=OFF
		-DJPEGXL_ENABLE_MANPAGES=OFF
		-DJPEGXL_ENABLE_JNI=OFF
		-DJPEGXL_ENABLE_TCMALLOC=OFF
		-DJPEGXL_ENABLE_EXAMPLES=OFF
	)

	if multilib_is_native_abi; then
		mycmakeargs+=(
			-DJPEGXL_ENABLE_TOOLS=ON
			-DJPEGXL_ENABLE_OPENEXR=$(usex openexr)
		)
	else
		mycmakeargs+=(
			-DJPEGXL_ENABLE_TOOLS=OFF
			-DJPEGXL_ENABLE_OPENEXR=OFF
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	find "${D}" -name '*.a' -delete || die
}
