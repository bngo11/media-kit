# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MusicIP audio fingerprinting plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libofa-0.9.3-r1
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"