# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="bs2b elements for Gstreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
media-libs/libbs2b
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"