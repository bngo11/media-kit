# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DVB device capture plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
virtual/os-headers
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"