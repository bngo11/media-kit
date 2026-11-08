# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Speex encoder/decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/speex-1.2_rc1-r1
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"