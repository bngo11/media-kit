# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic meson

DESCRIPTION="Basepack of plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.22.7.tar.xz -> gst-plugins-good-1.22.7.tar.xz"

LICENSE="LGPL-2.1+"
KEYWORDS="*"
IUSE="nls +orc"
SLOT="1.0"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=media-libs/gst-plugins-base-${PV}:${SLOT}
	>=media-libs/gstreamer-${PV}:${SLOT}
	>=app-arch/bzip2-1.0.6-r4
	>=sys-libs/zlib-1.2.8-r1
	orc? ( >=dev-lang/orc-0.4.17 )

	!<=media-plugins/gst-plugins-cairo-1.16.3:1.0
	!<=media-plugins/gst-plugins-dv-1.16.3:1.0
	!<=media-plugins/gst-plugins-flac-1.16.3:1.0
	!<=media-plugins/gst-plugins-gdkpixbuf-1.16.3:1.0
	!<=media-plugins/gst-plugins-gtk-1.16.3:1.0
	!<=media-plugins/gst-plugins-jack-1.16.3:1.0
	!<=media-plugins/gst-plugins-jpeg-1.16.3:1.0
	!<=media-plugins/gst-plugins-lame-1.16.3:1.0
	!<=media-plugins/gst-plugins-libpng-1.16.3:1.0
	!<=media-plugins/gst-plugins-mpg123-1.16.3:1.0
	!<=media-plugins/gst-plugins-oss-1.16.3:1.0
	!<=media-plugins/gst-plugins-pulse-1.16.3:1.0
	!<=media-plugins/gst-plugins-raw1394-1.16.3:1.0
	!<=media-plugins/gst-plugins-shout2-1.16.3:1.0
	!<=media-plugins/gst-plugins-soup-1.16.3:1.0
	!<=media-plugins/gst-plugins-speex-1.16.3:1.0
	!<=media-plugins/gst-plugins-taglib-1.16.3:1.0
	!<=media-plugins/gst-plugins-twolame-1.16.3:1.0
	!<=media-plugins/gst-plugins-v4l2-1.16.3:1.0
	!<=media-plugins/gst-plugins-vpx-1.16.3:1.0
	!<=media-plugins/gst-plugins-wavpack-1.16.3:1.0
	!<=media-plugins/gst-plugins-ximagesrc-1.16.3:1.0
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=sys-apps/sed-4
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.17 )
"

src_configure() {
	# Always enable optional bz2 support for matroska
	# Always enable optional zlib support for qtdemux and matroska
	# Many media files require these to work, as some container headers are often
	# compressed, bug #291154
	local emesonargs=(
		-Dbz2=enabled
		-Dexamples=disabled
	)

	meson_src_configure
}
