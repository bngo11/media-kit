# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Implementation of the 3D Manufacturing Format file standard"
HOMEPAGE="https://3mf.io/ https://github.com/3MFConsortium/lib3mf"
SRC_URI="https://github.com/3MFConsortium/lib3mf/archive/refs/tags/v2.2.0.tar.gz -> lib3mf-2.2.0.tar.gz"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="*"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libzip:=
	sys-apps/util-linux
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-cpp/gtest
		dev-libs/openssl
		dev-util/valgrind
	)
"

PATCHES=(
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR="include/${PN}"
		-DLIB3MF_TESTS=$(usex test)
		-DUSE_INCLUDED_LIBZIP=OFF
		-DUSE_INCLUDED_ZLIB=OFF
	)

	if use test; then
		mycmakeargs+=(
			-DUSE_INCLUDED_GTEST=OFF
			# code says it uses libressl, but works with openssl too
			-DUSE_INCLUDED_SSL=OFF
		)
	fi

	cmake_src_configure
}
src_install() {                                    
        cmake_src_install                                 
                                           
        for suf in abi types implicit; do
                dosym /usr/include/${PN}/Bindings/Cpp/${PN}_${suf}.hpp /usr/include/${PN}/${PN}_${suf}.hpp 
        done                                                                            
}