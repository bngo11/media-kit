# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="A GStreamer based RTSP server"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-rtsp-server.html"
SRC_URI="https://gstreamer.freedesktop.org/src/gst-rtsp-server/gst-rtsp-server-1.24.5.tar.xz -> gst-rtsp-server-1.24.5.tar.xz"

LICENSE="LGPL-2+"
KEYWORDS="*"
IUSE="examples +introspection nls static-libs test"
SLOT="1.0"

# gst-plugins-base for many used elements and API
# gst-plugins-good for rtprtxsend and rtpbin elements, maybe more
# gst-plugins-srtp for srtpenc and srtpdec elements
RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=media-libs/gstreamer-${PV}:${SLOT}[introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[introspection?]
	>=media-libs/gst-plugins-good-${PV}:${SLOT}
	>=media-plugins/gst-plugins-srtp-${PV}:${SLOT}
	introspection? ( >=dev-libs/gobject-introspection-1.31.1:= )
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=sys-apps/sed-4
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.17 )
"

src_configure() {
	# debug: only adds -g to CFLAGS
	# docbook: nothing behind that switch
	# libcgroup is automagic and only used in examples
	local emesonargs=(
		$(meson_feature examples)
		$(meson_feature introspection)
		$(meson_feature test tests)
	)

	meson_src_configure
}