# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="H.264 encoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/x264-0.0.20130506:=
>=media-libs/gst-plugins-ugly-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"