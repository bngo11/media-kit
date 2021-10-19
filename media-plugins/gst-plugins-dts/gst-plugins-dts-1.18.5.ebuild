# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DTS audio decoder plugin for Gstreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE="+orc"

RDEPEND="
>=media-libs/libdca-0.0.5-r3
orc? ( >=dev-lang/orc-0.4.17 )
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"