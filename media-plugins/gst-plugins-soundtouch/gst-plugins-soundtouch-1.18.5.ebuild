# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Beats-per-minute detection and pitch controlling plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/libsoundtouch-1.7.1
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"