# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Color management correction GStreamer plugins"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/lcms-2.7:2
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"