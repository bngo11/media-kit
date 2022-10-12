# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic meson

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.20.4.tar.xz -> gst-plugins-base-1.20.4.tar.xz"

LICENSE="GPL-2+ LGPL-2+"
KEYWORDS="*"
SLOT="1.0"

# For OpenGL we have three separate concepts, with a list of possibilities in each:
#  * opengl APIs - opengl and/or gles2; USE=opengl and USE=gles2 enable these accordingly; if neither is enabled, OpenGL helper library and elements are not built at all and all the other options aren't relevant
#  * opengl platforms - glx and/or egl; also cgl, wgl, eagl for non-linux; USE="X opengl" enables glx platform; USE="egl" enables egl platform. Rest is up for relevant prefix teams.
#  * opengl windowing system - x11, wayland, win32, cocoa, android, viv_fb, gbm and/or dispmanx; USE=X enables x11 (but for WSI it's automagic - FIXME), USE=wayland enables wayland, USE=gbm enables gbm (automagic upstream - FIXME); rest is up for relevant prefix/arch teams/contributors to test and provide patches
# With the following limitations:
#  * If opengl and/or gles2 is enabled, a platform has to be enabled - x11 or egl in our case, but x11 (glx) is acceptable only with opengl
#  * If opengl and/or gles2 is enabled, a windowing system has to be enabled - x11, wayland or gbm in our case
#  * glx platform requires opengl API
#  * wayland, gbm and most other non-glx WSIs require egl platform
# Additionally there is optional dmabuf support with egl for additional dmabuf based upload/download/eglimage options;
#  and optional graphene usage for gltransformation and glvideoflip elements and more GLSL Uniforms support in glshader;
#  and libpng/jpeg are required for gloverlay element;

# Keep default IUSE options for relevant ones mirrored with gst-plugins-gtk and gst-plugins-bad
IUSE="alsa +egl gbm gles2 +introspection ivorbis nls +ogg +opengl +orc +pango theora +vorbis wayland +X"
GL_REQUIRED_USE="
	|| ( gbm wayland X )
	wayland? ( egl )
	gbm? ( egl )
"
REQUIRED_USE="
	ivorbis? ( ogg )
	theora? ( ogg )
	vorbis? ( ogg )
	opengl? ( || ( egl X ) ${GL_REQUIRED_USE} )
	gles2? ( egl ${GL_REQUIRED_USE} )
"

# Dependencies needed by opengl library and plugin (enabled via USE gles2 and/or opengl)
# dmabuf automagic from libdrm headers (drm_fourcc.h) and EGL, so ensure it with USE=egl (platform independent header used only, thus no MULTILIB_USEDEP); provides dmabuf based upload/download/eglimage options
GL_DEPS="
	>=media-libs/mesa-9.0[egl?,gbm?,gles2?,wayland?]
	egl? (
		x11-libs/libdrm
	)
	gbm? (
		>=dev-libs/libgudev-147
		>=x11-libs/libdrm-2.4.55
	)
	wayland? (
		dev-libs/wayland
	)

	>=media-libs/graphene-1.10.0
	media-libs/libpng:0
	virtual/jpeg:0
" # graphene for optional gltransformation and glvideoflip elements and more GLSL Uniforms support in glshader; libpng/jpeg for gloverlay element

RDEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.40.0:2
	>=media-libs/gstreamer-${PV}:1.0[introspection?]
	>=sys-libs/zlib-1.2.8-r1
	alsa? ( >=media-libs/alsa-lib-1.0.27.2 )
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
	ivorbis? ( >=media-libs/tremor-0_pre20130223 )
	ogg? ( >=media-libs/libogg-1.3.0 )
	orc? ( >=dev-lang/orc-0.4.24 )
	pango? ( >=x11-libs/pango-1.36.3 )
	theora? ( >=media-libs/libtheora-1.1.1[encode] )
	vorbis? ( >=media-libs/libvorbis-1.3.3-r1 )
	X? (
		>=x11-libs/libX11-1.6.2
		>=x11-libs/libXext-1.3.2
		>=x11-libs/libXv-1.0.10
	)

	gles2? ( ${GL_DEPS} )
	opengl? ( ${GL_DEPS} )

	!<media-libs/gst-plugins-bad-1.16.3:1.0
	!<=media-plugins/gst-plugins-opus-1.16.3:1.0
	!<=media-plugins/gst-plugins-cdparanoia-1.16.3:1.0
	!<=media-plugins/gst-plugins-libvisual-1.16.3:1.0
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	X? ( x11-base/xorg-proto )
	app-arch/xz-utils
	>=sys-apps/sed-4
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.17 )
"

src_prepare() {
	# Disable GL tests for now; prone to fail with EGL_NOT_INITIALIZED, etc
	sed -i -e '/^@USE_GL_TRUE@/d' tests/check/Makefile.in
	default
}

src_configure() {
	filter-flags -mno-sse -mno-sse2 -mno-sse4.1 #610340
	local gl_api=""
	local gl_platform=""
	local gl_winsys=""

	local emesonargs=(
		$(meson_feature alsa)
		$(meson_feature introspection)
		$(meson_feature ivorbis tremor)
		$(meson_feature ogg)
		$(meson_feature orc)
		$(meson_feature pango)
		$(meson_feature theora)
		$(meson_feature vorbis)
		$(meson_feature X x11)
		$(meson_feature X xshm)
		$(meson_feature X xvideo)
		$(meson_feature X x11)
		-Diso-codes=enabled
		-Dexamples=disabled
	)

	if use opengl; then
		gl_api="opengl"
	fi

	if use gles2; then
		gl_api="$gl_api,gles2"
	fi

	if use egl; then
		gl_platform="egl"
	fi

	if use opengl && use X; then
		gl_platform="$gl_platform,glx"
	fi

	# FIXME: Automagic gbm and x11 wsi
	if use opengl || use gles2; then
                gl_winsys="x11"                                                                                                                                                                                      
                if use wayland; then                                                                                                                                                                                 
                        gl_winsys="$gl_winsys,wayland"                                                                                                                                                               
                fi                                                                                                                                                                                                   
                                                                                                                                                                                                                     
		emesonargs+=(
			-Dgl=enabled
			-Dgl-graphene=enabled
			-Dgl-jpeg=enabled
			-Dgl-png=enabled
		)
	else
		emesonargs+=(
			-Dgl=disabled
			-Dgl-graphene=disabled
			-Dgl-jpeg=disabled
			-Dgl-png=disabled
		)
	fi

	emesonargs+=(
		-Dgl_api=$gl_api
		-Dgl_platform=$gl_platform
		-Dgl_winsys=$gl_winsys
	)

	meson_src_configure
}

src_test() {
	unset GSETTINGS_BACKEND
	emake check
}