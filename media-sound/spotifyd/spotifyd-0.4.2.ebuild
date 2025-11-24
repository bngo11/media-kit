# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A spotify daemon"
HOMEPAGE="https://github.com/Spotifyd/spotifyd"
SRC_URI="https://github.com/Spotifyd/spotifyd/tarball/01480e68acba82408f550e446abe00c9992a60d8 -> spotifyd-0.4.2-01480e6.tar.gz
https://direct.funtoo.org/e1/2e/79/e12e794a836c3d1ad868fe2edd474be0401ded5364dedacd71befec110d66f947baee3ab98191c02d21f2e5a2b68a9b957743fe9618331a55ed06847562eec0d -> spotifyd-0.4.2-funtoo-crates-bundle-fdf19ad58bc378558c6d1d7e955b807426eab9ffb3e19670eb5a50ec6771585aa432d2ce769f2784b880d9b777f28ae107e002fc2c6cd2919c366c5a9ba61ca5.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 GPL-3 ISC MIT MPL-2.0 ZLIB"
KEYWORDS="*"
SLOT="0"
IUSE="+alsa dbus portaudio pulseaudio rodio"
REQUIRED_USE="|| ( alsa portaudio pulseaudio rodio ) rodio? ( alsa )"

RDEPEND="
	dev-libs/openssl:0=
	alsa? ( media-libs/alsa-lib )
	dbus? ( sys-apps/dbus )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( {CHANGELOG,README}.md )

QA_FLAGS_IGNORED="usr/bin/spotifyd"

post_src_unpack() {
	rm -rf "${S}"
	mv "${WORKDIR}"/Spotifyd-spotifyd-* "${S}" || die
}

src_configure() {
	myfeatures=(
		"$(usex alsa alsa_backend '')"
		"$(usex dbus "dbus_keyring dbus_mpris" '')"
		"$(usex portaudio portaudio_backend '')"
		"$(usex pulseaudio pulseaudio_backend '')"
		"$(usex rodio rodio_backend '')"
	)
}

src_install() {
	einstalldocs

	insinto /etc
	doins "${FILESDIR}"/spotifyd.conf

	cargo_src_install ${myfeatures:+--features "${myfeatures[*]}"} --no-default-features
}