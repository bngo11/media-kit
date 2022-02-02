# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic virtualx meson

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.18.6.tar.xz"

LICENSE="LGPL-2"
KEYWORDS="*"
SLOT="1.0"

# TODO: egl and gtk IUSE only for transition
IUSE="X bzip2 +egl gles2 gtk +introspection nls +opengl +orc vnc wayland" # Keep default IUSE mirrored with gst-plugins-base where relevant

# X11 is automagic for now, upstream #709530 - only used by librfb USE=vnc plugin
# We mirror opengl/gles2 from -base to ensure no automagic openglmixers plugin (with "opengl?" it'd still get built with USE=-opengl here)
RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=media-libs/gstreamer-${PV}:${SLOT}[introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[egl?,introspection?,gles2=,opengl=]
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )

	bzip2? ( >=app-arch/bzip2-1.0.6-r4 )
	vnc? ( X? ( x11-libs/libX11 ) )
	wayland? (
		>=dev-libs/wayland-1.4.0
		>=x11-libs/libdrm-2.4.55
		>=dev-libs/wayland-protocols-1.4
	)

	gtk? ( >=media-plugins/gst-plugins-gtk-${PV}:${SLOT} )
	orc? ( >=dev-lang/orc-0.4.17 )

	!<=media-plugins/gst-plugins-assrender-1.16.3:1.0
	!<=media-plugins/gst-plugins-bluez-1.16.3:1.0
	!<=media-plugins/gst-plugins-bs2b-1.16.3:1.0
	!<=media-plugins/gst-plugins-chromaprint-1.16.3:1.0
	!<=media-plugins/gst-plugins-colormanagement-1.16.3:1.0
	!<=media-plugins/gst-plugins-dash-1.16.3:1.0
	!<=media-plugins/gst-plugins-dtls-1.16.3:1.0
	!<=media-plugins/gst-plugins-dts-1.16.3:1.0
	!<=media-plugins/gst-plugins-dvb-1.16.3:1.0
	!<=media-plugins/gst-plugins-faac-1.16.3:1.0
	!<=media-plugins/gst-plugins-faad-1.16.3:1.0
	!<=media-plugins/gst-plugins-hls-1.16.3:1.0
	!<=media-plugins/gst-plugins-kate-1.16.3:1.0
	!<=media-plugins/gst-plugins-ladspa-1.16.3:1.0
	!<=media-plugins/gst-plugins-libde265-1.16.3:1.0
	!<=media-plugins/gst-plugins-libmms-1.16.3:1.0
	!<=media-plugins/gst-plugins-lv2-1.16.3:1.0
	!<=media-plugins/gst-plugins-modplug-1.16.3:1.0
	!<=media-plugins/gst-plugins-mpeg2enc-1.16.3:1.0
	!<=media-plugins/gst-plugins-mplex-1.16.3:1.0
	!<=media-plugins/gst-plugins-neon-1.16.3:1.0
	!<=media-plugins/gst-plugins-ofa-1.16.3:1.0
	!<=media-plugins/gst-plugins-opencv-1.16.3:1.0
	!<=media-plugins/gst-plugins-openh264-1.16.3:1.0
	!<=media-plugins/gst-plugins-resindvd-1.16.3:1.0
	!<=media-plugins/gst-plugins-rtmp-1.16.3:1.0
	!<=media-plugins/gst-plugins-smoothstreaming-1.16.3:1.0
	!<=media-plugins/gst-plugins-soundtouch-1.16.3:1.0
	!<=media-plugins/gst-plugins-srtp-1.16.3:1.0
	!<=media-plugins/gst-plugins-uvch264-1.16.3:1.0
	!<=media-plugins/gst-plugins-voaacenc-1.16.3:1.0
	!<=media-plugins/gst-plugins-voamrwbenc-1.16.3:1.0
	!<=media-plugins/gst-plugins-x265-1.16.3:1.0
	!<=media-plugins/gst-plugins-zbar-1.16.3:1.0
	!<=media-plugins/gst-transcoder-1.16.3:1.0
"

DEPEND="${RDEPEND}
	dev-util/glib-utils
	app-arch/xz-utils
	>=sys-apps/sed-4
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.17 )
"

RESTRICT="test"

src_prepare() {
	default
	addpredict /dev # Prevent sandbox violations bug #570624
}

src_configure() {
	local emesonargs=(
		$(meson_feature introspection)
		$(meson_feature bzip2 bz2)
		$(meson_feature orc)
		$(meson_feature vnc librfb)
		$(meson_feature wayland)
		$(meson_feature X x11)
		-Dexamples=disabled
		-Dgst_player_tests=false
		-Dshm=enabled
		-Dipcpipeline=enabled
	)

	if use opengl || use gles2; then
		emesonargs+=( -Dgl=enabled )
	else
		emesonargs+=( -Dgl=disabled )
	fi

	meson_src_configure
}

src_test() {
	unset DISPLAY
	# Tests are slower than upstream expects
	virtx emake check CK_DEFAULT_TIMEOUT=300
}
