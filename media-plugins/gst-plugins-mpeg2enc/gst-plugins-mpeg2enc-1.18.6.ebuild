# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MPEG-1/2 video encoding plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-video/mjpegtools-2.1.0-r1
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"