# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Basepack of plugins for gstreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"
SRC_URI="https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.22.4.tar.xz -> gst-plugins-ugly-1.22.4.tar.xz"

LICENSE="LGPL-2+" # some split plugins are LGPL but combining with a GPL library
KEYWORDS="*"
SLOT="1.0"
IUSE="nls"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=media-libs/gstreamer-${PV}:${SLOT}
	>=media-libs/gst-plugins-base-${PV}:${SLOT}

	!<=media-plugins/gst-plugins-a52dec-1.16.3:1.0
	!<=media-plugins/gst-plugins-amr-1.16.3:1.0
	!<=media-plugins/gst-plugins-cdio-1.16.3:1.0
	!<=media-plugins/gst-plugins-dvdread-1.16.3:1.0
	!<=media-plugins/gst-plugins-mpeg2dec-1.16.3:1.0
	!<=media-plugins/gst-plugins-sidplay-1.16.3:1.0
	!<=media-plugins/gst-plugins-x264-1.16.3:1.0
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=sys-apps/sed-4
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.17 )
"
