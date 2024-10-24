# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg

DESCRIPTION="Library for video acquisition using Genicam cameras"
HOMEPAGE="https://github.com/AravisProject/aravis"
SRC_URI="https://github.com/AravisProject/aravis/releases/download/0.8.21/aravis-0.8.21.tar.xz -> aravis-0.8.21.tar.xz"
KEYWORDS="*"

LICENSE="LGPL-2+"
SLOT="0"
IUSE="gtk-doc fast-heartbeat gstreamer introspection packet-socket test usb viewer"
RESTRICT="!test? ( test )"

GST_DEPEND="
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
"
BDEPEND="
	dev-util/glib-utils
	virtual/pkgconfig
	gtk-doc? (
		dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3
	)
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="
	dev-libs/glib:2[gtk-doc?]
	dev-libs/libxml2:2
	sys-libs/zlib
	gstreamer? ( ${GST_DEPEND} )
	packet-socket? ( sys-process/audit )
	usb? ( virtual/libusb:1 )
	viewer? (
		${GST_DEPEND}
		x11-libs/gtk+:3
		x11-libs/libnotify
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_feature gtk-doc documentation)
		$(meson_use fast-heartbeat)
		$(meson_feature gstreamer gst-plugin)
		$(meson_feature introspection)
		$(meson_feature packet-socket)
		$(meson_use test tests)
		$(meson_feature usb)
		$(meson_feature viewer)
	)

	meson_src_configure
}