# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DTLS encoder/decoder with SRTP support plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE="libressl"

RDEPEND="
libressl? ( dev-libs/libressl:= )
!libressl? ( >=dev-libs/openssl-1.0.1:0= )
>=media-libs/gst-plugins-bad-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"