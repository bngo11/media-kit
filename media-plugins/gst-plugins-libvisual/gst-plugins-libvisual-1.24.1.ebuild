# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Visualization elements for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libvisual-0.4.0-r3
>=media-plugins/libvisual-plugins-0.4.0-r3
>=media-libs/gst-plugins-base-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"