# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Image decoder, overlay and sink plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=x11-libs/gdk-pixbuf-2.30.7:2
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"