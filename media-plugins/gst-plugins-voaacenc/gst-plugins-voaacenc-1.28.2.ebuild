# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="AAC encoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/vo-aacenc-0.1.3
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"