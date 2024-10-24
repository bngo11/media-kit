# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="https://libjpeg-turbo.org/ https://sourceforge.net/projects/libjpeg-turbo/"
SRC_URI="https://github.com/libjpeg-turbo/libjpeg-turbo/tarball/c5f269eb9665435271c05fbcaf8721fa58e9eafa -> libjpeg-turbo-2.1.3-c5f269e.tar.gz"

LICENSE="BSD IJG ZLIB"
SLOT="0/0.2"
KEYWORDS="*"
IUSE="cpu_flags_arm_neon static-libs"

ASM_DEPEND="|| ( dev-lang/nasm dev-lang/yasm )"

COMMON_DEPEND="!media-libs/jpeg:0
	!media-libs/jpeg:62"

BDEPEND=">=dev-util/cmake-3.16.5
	amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )
	amd64-fbsd? ( ${ASM_DEPEND} )
	x86-fbsd? ( ${ASM_DEPEND} )
	amd64-linux? ( ${ASM_DEPEND} )
	x86-linux? ( ${ASM_DEPEND} )
	x64-macos? ( ${ASM_DEPEND} )
	x64-cygwin? ( ${ASM_DEPEND} )"

DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv ${WORKDIR}/libjpeg-turbo* ${S} || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DEFAULT_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DENABLE_STATIC="$(usex static-libs)"
		-DWITH_JAVA=OFF
		-DWITH_MEM_SRCDST=ON
	)

	# Avoid ARM ABI issues by disabling SIMD for CPUs without NEON. #792810
	if use arm; then
		mycmakeargs+=(
			-DWITH_SIMD:BOOL=$(usex cpu_flags_arm_neon ON OFF)
		)
	fi

	# mostly for Prefix, ensure that we use our yasm if installed and
	# not pick up host-provided nasm
	if has_version -b dev-lang/yasm && ! has_version -b dev-lang/nasm; then
		mycmakeargs+=(
			-DCMAKE_ASM_NASM_COMPILER=$(type -P yasm)
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${ED}" -type f -name '*.la' -delete || die

	local -a DOCS=( README.md ChangeLog.md )
	einstalldocs

	docinto html
	dodoc -r "${S}"/doc/html/.
}