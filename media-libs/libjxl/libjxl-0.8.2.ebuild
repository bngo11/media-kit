# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

# This changes frequently.  Please check the testdata submodule when bumping.
TESTDATA_COMMIT="d6168ffb9e1cc24007e64b65dd84d822ad1fc759"
DESCRIPTION="JPEG XL image format reference implementation"
HOMEPAGE="https://github.com/libjxl/libjxl"
SRC_URI="https://github.com/libjxl/libjxl/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/libjxl/testdata/archive/${TESTDATA_COMMIT}.tar.gz
		-> ${PN}-testdata-${TESTDATA_COMMIT}.tar.gz )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="openexr test"
RESTRICT="!test? ( test )"

DEPEND="app-arch/brotli:=
	>=dev-cpp/highway-1.0.0
	media-libs/giflib:=
	>=media-libs/lcms-2.13:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	>=x11-misc/shared-mime-info-2.2
	openexr? ( media-libs/openexr:= )
	test? ( dev-cpp/gtest )
"
RDEPEND="${DEPEND}"
PATCHES=(
	"${FILESDIR}/${PN}-0.8.2-backport-pr2596.patch"
	"${FILESDIR}/${PN}-0.8.2-backport-pr2617.patch"
)

src_configure() {
	filter-lto

	local mycmakeargs=(
		-DJPEGXL_ENABLE_BENCHMARK=OFF
		-DJPEGXL_ENABLE_COVERAGE=OFF
		-DJPEGXL_ENABLE_FUZZERS=OFF
		-DJPEGXL_ENABLE_SJPEG=OFF
		-DJPEGXL_WARNINGS_AS_ERRORS=OFF

		-DJPEGXL_ENABLE_SKCMS=OFF
		-DJPEGXL_ENABLE_VIEWERS=OFF
		-DJPEGXL_ENABLE_PLUGINS=OFF
		-DJPEGXL_FORCE_SYSTEM_BROTLI=ON
		-DJPEGXL_FORCE_SYSTEM_GTEST=ON
		-DJPEGXL_FORCE_SYSTEM_HWY=ON
		-DJPEGXL_FORCE_SYSTEM_LCMS2=ON
		-DJPEGXL_ENABLE_DOXYGEN=OFF
		-DJPEGXL_ENABLE_MANPAGES=OFF
		-DJPEGXL_ENABLE_JNI=OFF
		-DJPEGXL_ENABLE_JPEGLI_LIBJPEG=OFF
		-DJPEGXL_ENABLE_TCMALLOC=OFF
		-DJPEGXL_ENABLE_EXAMPLES=OFF
	)

	mycmakeargs+=(
		-DJPEGXL_ENABLE_TOOLS=ON
		-DJPEGXL_ENABLE_OPENEXR=$(usex openexr)
		-DBUILD_TESTING=$(usex test ON OFF)
	)
	use test &&
		mycmakeargs+=( -DJPEGXL_TEST_DATA_PATH="${WORKDIR}/testdata-${TESTDATA_COMMIT}" )

	cmake_src_configure
}

src_install() {
	cmake_src_install

	find "${ED}" -name '*.a' -delete || die
}
