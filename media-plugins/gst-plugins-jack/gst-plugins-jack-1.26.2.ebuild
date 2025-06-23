# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="JACK audio server source/sink plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
virtual/jack
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"