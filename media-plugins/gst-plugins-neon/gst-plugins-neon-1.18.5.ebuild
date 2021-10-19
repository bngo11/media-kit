# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="HTTP client source plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=net-libs/neon-0.30.0
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"