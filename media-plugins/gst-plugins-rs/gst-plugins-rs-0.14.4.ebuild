# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="GStreamer GTK 4 sink element"
HOMEPAGE="https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
SRC_URI=" https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/0.14.4/gst-plugins-rs-0.14.4.tar.gz -> gst-plugins-rs-0.14.4.tar.gz "

LICENSE="MPL-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="1.0"
KEYWORDS="*"
IUSE="+egl +gles2 opengl +wayland +X" # Keep default IUSE mirrored with gst-plugins-base
RESTRICT="network-sandbox"

DEPEND="
	dev-libs/glib
	>=gui-libs/gtk-4.16:4
	>=media-libs/gstreamer-1.24:1.0
	>=media-libs/gst-plugins-base-1.24:${SLOT}[egl=,gles2=,opengl=,wayland=,X=]
	>=media-sound/csound-6.17
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-util/cargo-c
"

src_configure() {
	local emesonargs=(
		-Dgtk4=enabled
	)

	meson_src_configure
}
