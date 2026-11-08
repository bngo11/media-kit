# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GStreamer Transcoding API"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
dev-libs/gobject-introspection:=
dev-libs/glib:2
>=media-libs/gstreamer-${PV}:1.0[introspection]
>=media-libs/gst-plugins-base-${PV}:1.0[introspection]
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"