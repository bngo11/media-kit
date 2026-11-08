# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DVD playback support plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libdvdnav-4.2.0-r1
>=media-libs/libdvdread-4.2.0-r1
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"