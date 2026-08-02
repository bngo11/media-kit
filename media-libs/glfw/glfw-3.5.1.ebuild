# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Portable OpenGL FrameWork"
HOMEPAGE="https://www.glfw.org/"
SRC_URI="https://github.com/glfw/glfw/tarball/70a9bb3881fe80fd483236e2b203cb451c6ecf40 -> glfw-3.5.1-70a9bb3.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="*"
IUSE="X wayland"

RDEPEND="
    x11-libs/libxkbcommon
    wayland? (
        dev-libs/wayland
        media-libs/mesa[egl(+),wayland]
    )
    X? (
        virtual/opengl
        x11-libs/libX11
        x11-libs/libXcursor
        x11-libs/libXinerama
        x11-libs/libXrandr
        x11-libs/libXxf86vm
    )
"
DEPEND="
    ${RDEPEND}
    wayland? ( dev-libs/wayland-protocols )
    X? (
        x11-base/xorg-proto
        x11-libs/libXi
    )
"
BDEPEND="
    wayland? (
        dev-util/wayland-scanner
        kde-frameworks/extra-cmake-modules
    )
"

src_unpack() {
    default
    rm -rf "${S}"
    mv "${WORKDIR}"/glfw-glfw-* "${S}" || die
}

src_configure() {
    local mycmakeargs=(
        -DGLFW_BUILD_EXAMPLES=no
        -DGLFW_BUILD_X11="$(usex X)"
        -DGLFW_BUILD_WAYLAND="$(usex wayland)"
        -DBUILD_SHARED_LIBS=1
    )
    cmake_src_configure
}