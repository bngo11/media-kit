# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic toolchain-funcs

MY_PN=OpenEXR
MY_PV=$(ver_cut 1)
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="ILM's OpenEXR high dynamic-range image file format libraries"
HOMEPAGE="https://www.openexr.com/"
SRC_URI="https://api.github.com/repos/AcademySoftwareFoundation/openexr/tarball/refs/tags/v3.1.2 -> openexr-3.1.2-2eec453b01b1187873474f31eb5b127b0a52e4ff.tar.gz"

LICENSE="BSD"
SLOT="2/30" # based on SONAME
KEYWORDS="*"
IUSE="cpu_flags_x86_avx doc examples large-stack static-libs utils test threads"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/imath-3.1.0:=
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/openexr-3.1.1-0001-changes-needed-for-proper-slotting.patch
	"${FILESDIR}"/openexr-3.1.1-0002-add-version-to-binaries-for-slotting.patch
	"${FILESDIR}"/openexr-3.1.1-0003-disable-failing-test.patch
)

DOCS=( CHANGES.md GOVERNANCE.md PATENTS README.md SECURITY.md docs/SymbolVisibility.md )

post_src_unpack() {
	mv "${WORKDIR}/"AcademySoftwareFoundation-openexr* "${S}" || die
}

src_prepare() {
	# Fix path for testsuite
	sed -e "s:/var/tmp/:${T}:" \
		-i "${S}"/src/test/${MY_PN}{,Fuzz,Util}Test/tmpDir.h || die "failed to set temp path for tests"

	cmake_src_prepare

	mv "${S}"/cmake/${MY_PN}.pc.in "${S}"/cmake/${MY_P}.pc.in || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DBUILD_TESTING=$(usex test)
		-DOPENEXR_BUILD_TOOLS=$(usex utils)
		-DOPENEXR_ENABLE_LARGE_STACK=$(usex large-stack)
		-DOPENEXR_ENABLE_THREADING=$(usex threads)
		-DOPENEXR_INSTALL_EXAMPLES=$(usex examples)
		-DOPENEXR_INSTALL_PKG_CONFIG=ON
		-DOPENEXR_INSTALL_TOOLS=$(usex utils)
		-DOPENEXR_OUTPUT_SUBDIR="${MY_P}"
		-DOPENEXR_USE_CLANG_TIDY=OFF		# don't look for clang-tidy
	)

	use test && mycmakeargs+=( -DOPENEXR_RUN_FUZZ_TESTS=ON )

	cmake_src_configure
}

src_install() {
	if use doc; then
		DOCS+=( docs/*.pdf )
	fi
	use examples && docompress -x /usr/share/doc/${PF}/examples
	cmake_src_install

	newenvd - 99${PN}3 <<-EOF
		LDPATH=/usr/$(get_libdir)/${MY_P}
	EOF
}