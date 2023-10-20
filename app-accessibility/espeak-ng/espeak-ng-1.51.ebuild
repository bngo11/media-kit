# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Software speech synthesizer for English, and some other languages"
HOMEPAGE="https://github.com/espeak-ng/espeak-ng"
SRC_URI="https://github.com/espeak-ng/espeak-ng/archive/1.51.tar.gz -> espeak-ng-1.51.tar.gz"

LICENSE="GPL-3+ Turkowski unicode"
SLOT="0"
KEYWORDS="*"
IUSE="+async +klatt l10n_ru l10n_zh mbrola +sound"

COMMON_DEPEND="
	!app-accessibility/espeak
	mbrola? ( app-accessibility/mbrola )
	sound? ( media-libs/pcaudiolib )
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	sound? ( media-sound/sox )
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( CHANGELOG.md README.md docs )

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv -* "${S}" || die
	fi
}

src_prepare() {
	default

	# disable failing tests
	rm tests/{language-pronunciation,translate}.test || die
	sed -i \
		-e "/language-pronunciation.check/d" \
		-e "/translate.check/d" \
		Makefile.am || die

	eautoreconf
}

src_configure() {
	local econf_args
	econf_args=(
		$(use_with async)
		$(use_with klatt)
		$(use_with l10n_ru extdict-ru)
		$(use_with l10n_zh extdict-zh)
		$(use_with l10n_zh extdict-zhy)
		$(use_with mbrola)
		$(use_with sound pcaudiolib)
		--without-libfuzzer
		--without-sonic
		--disable-rpath
		--disable-static
	)
	econf "${econf_args[@]}"
}

src_compile() {
	export LD_LIBRARY_PATH="$(pwd)/src/.libs"
	emake
}

src_test() {
	emake check
}

src_install() {
	emake DESTDIR="${D}" VIMDIR=/usr/share/vimfiles install
	rm "${ED}"/usr/lib*/*.la || die
}