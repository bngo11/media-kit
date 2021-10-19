# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenCV elements for Gstreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/opencv-2.3.0[contrib(+)]
<media-libs/opencv-3.5
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"