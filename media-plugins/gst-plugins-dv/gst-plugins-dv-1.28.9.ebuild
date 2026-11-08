# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DV demuxer and decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libdv-1.0.0-r3
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"