# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="AAC audio decoder plugin."
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/faad2-2.7-r3
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"