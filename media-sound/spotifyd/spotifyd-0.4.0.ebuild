# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A spotify daemon"
HOMEPAGE="https://github.com/Spotifyd/spotifyd"
SRC_URI="https://github.com/Spotifyd/spotifyd/tarball/d24db14741492a2ca3f5df13103abf2bb77f5625 -> spotifyd-0.4.0-d24db14.tar.gz
https://direct.funtoo.org/df/6f/20/df6f20cae2ccb11afd6ffe8756c698a6b01188ca319838b0727eea96ea4f61f71a57d11250d38a5b5d90a1af875c37d94edbad2c93f794efed9d648a09c1f49e -> spotifyd-0.4.0-funtoo-crates-bundle-5718a12b351419fb7cd734b92428cf3f53529f716e88cb11ae9c1a3c82a932afc6a9d8df15143199ea7d3e1da846688b308110232bcf49e0fbd2948c8af737be.tar.gz"

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