# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="RTMP source/sink plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-video/rtmpdump-2.4_p20131018
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"