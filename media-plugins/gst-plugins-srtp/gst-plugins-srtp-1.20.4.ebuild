# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SRTP encoder/decoder plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=net-libs/libsrtp-2.1.0:2=
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"