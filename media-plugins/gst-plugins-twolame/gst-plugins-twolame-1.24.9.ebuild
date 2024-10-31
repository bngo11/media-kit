# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MPEG2 encoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-sound/twolame-0.3.13-r1
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"