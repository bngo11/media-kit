# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_REQ_USE="xml"
PYTHON_COMPAT=( python3+ )

inherit meson python-any-r1

DESCRIPTION="Reusable library for GPU-accelerated image processing primitives"
HOMEPAGE="https://code.videolan.org/videolan/libplacebo"
SRC_URI="https://code.videolan.org/videolan/libplacebo/-/archive/v5.229.2/libplacebo-v5.229.2.tar.gz -> libplacebo-v5.229.2.tar.gz
	https://github.com/Dav1dde/glad/archive/refs/tags/v2.0.3.tar.gz -> libplacebo-glad-2.0.3.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"
KEYWORDS="*"

GLAD_PV=2.0.3

LICENSE="LGPL-2.1+ opengl? ( MIT )"
SLOT="0/$(ver_cut 2)" # soname
IUSE="glslang lcms llvm-libunwind +opengl +shaderc test unwind +vulkan"
RESTRICT="!test? ( test )"
REQUIRED_USE="vulkan? ( || ( glslang shaderc ) )"

# libglvnd is used with dlopen() through glad (inc. egl/gles)
RDEPEND="
	lcms? ( media-libs/lcms:2 )
	opengl? ( media-libs/libglvnd )
	shaderc? ( media-libs/shaderc )
	!shaderc? ( glslang? ( dev-util/glslang:= ) )
	unwind? (
		llvm-libunwind? ( sys-libs/llvm-libunwind )
		!llvm-libunwind? ( sys-libs/libunwind:= )
	)
	vulkan? ( media-libs/vulkan-loader )"
# vulkan-headers is required even with USE=-vulkan (bug #882065)
DEPEND="
	${RDEPEND}
	dev-util/vulkan-headers"
BDEPEND="
	$(python_gen_any_dep 'dev-python/jinja[${PYTHON_USEDEP}]')
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-5.229.1-llvm-libunwind.patch
	"${FILESDIR}"/${PN}-5.229.1-python-executable.patch
	"${FILESDIR}"/${PN}-5.229.1-shared-glslang.patch
)

python_check_deps() {
	python_has_version "dev-python/jinja[${PYTHON_USEDEP}]"
}

src_unpack() {
	default
	if use opengl; then
		rmdir "${S}"/3rdparty/glad || die
		mv glad-${GLAD_PV} "${S}"/3rdparty/glad || die
	fi
}

src_configure() {
	local emesonargs=(
		-Ddemos=false #851927
		$(meson_use test tests)
		$(meson_feature lcms)
		$(meson_feature opengl)
		$(meson_feature opengl gl-proc-addr)
		$(meson_feature shaderc)
		$(usex shaderc -Dglslang=disabled $(meson_feature glslang))
		$(meson_feature unwind)
		$(meson_feature vulkan)
		$(meson_feature vulkan vk-proc-addr)
		-Dvulkan-registry="${ESYSROOT}"/usr/share/vulkan/registry/vk.xml
	)

	meson_src_configure
}