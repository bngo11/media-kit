# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Ladspa elements for Gstreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/ladspa-sdk-1.13-r2
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"