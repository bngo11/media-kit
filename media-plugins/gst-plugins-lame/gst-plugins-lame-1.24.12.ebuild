# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MP3 encoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-sound/lame-3.99.5-r1
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"