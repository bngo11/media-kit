# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="FLAC encoder/decoder/tagger plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/flac-1.2.1-r5
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"