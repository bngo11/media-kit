# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ID3v2/APEv2 tagger plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/taglib-1.9.1
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"