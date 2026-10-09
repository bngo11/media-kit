# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ATSC A/52 audio decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE="+orc"

RDEPEND="
>=media-libs/a52dec-0.7.4-r6
orc? ( >=dev-lang/orc-0.4.17 )
>=media-libs/gst-plugins-ugly-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"