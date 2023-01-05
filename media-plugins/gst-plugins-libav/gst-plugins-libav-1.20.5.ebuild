# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

MY_PN="gst-libav"

DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="https://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.20.5.tar.xz -> gst-libav-1.20.5.tar.xz"

LICENSE="LGPL-2+"
SLOT="1.0"
KEYWORDS="*"
IUSE="+orc"

RDEPEND="
	>=dev-libs/glib-2.40.0:2
	>=media-libs/gstreamer-${PV}:1.0
	>=media-libs/gst-plugins-base-${PV}:1.0
	>=media-video/ffmpeg-4:0=
	orc? ( >=dev-lang/orc-0.4.17 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${PV}"

RESTRICT="test" # FIXME: tests seem to get stuck at one point; investigate properly

src_configure() {
	local emesonargs=(
		-Dpackage-name="Funtoo GStreamer ebuild"
		-Dpackage-origin="https://www.funtoo.org"
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}