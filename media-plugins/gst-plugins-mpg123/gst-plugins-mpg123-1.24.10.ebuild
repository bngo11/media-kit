# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MP3 decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-sound/mpg123-1.23
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"