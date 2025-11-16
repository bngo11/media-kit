# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="PulseAudio sound server plugin for GStreamer"
KEYWORDS="*"
SLOT="1.0"
IUSE=""

RDEPEND="
>=media-libs/gst-plugins-base-${PV}:${SLOT}
>=media-sound/pulseaudio-2.1-r1
>=media-libs/gst-plugins-good-${PV%.*}:1.0=
"

DEPEND="${RDEPEND}"