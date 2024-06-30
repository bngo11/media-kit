# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/2f614700ab173a1d5b9569d33995f1870e5ed63e -> ncspot-1.1.1-2f61470.tar.gz
https://direct.funtoo.org/61/08/8c/61088c1066637c1abb8766f0b3bd9e224f99f6cc395d58312a51e8bb70c204bf695bb1c42c03357e71738a5017f0cdc180ddfc21d3a37cde4071a2b230f6f375 -> ncspot-1.1.1-funtoo-crates-bundle-b8138c43eae175b78329d45a17b13a429a8bbe2d9655a302d627a56031cb89841d38dd3fa72200e23e308e9de23b0f855c28931791f24ffe37cd441555406be4.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

DEPEND=""
RDEPEND=""
BDEPEND="virtual/rust"

DOCS=( README.md CHANGELOG.md )

QA_FLAGS_IGNORED="/usr/bin/ncspot"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/hrkfdn-ncspot-* ${S} || die
}