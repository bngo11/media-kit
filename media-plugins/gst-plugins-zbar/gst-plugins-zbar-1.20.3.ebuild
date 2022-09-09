# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Bar codes detection in video streams for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-gfx/zbar-0.10_p20121015-r2
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"