# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/31d3d79d6d5fae707cada54b2fc02a2cf8a5bc98 -> ncspot-1.2.2-31d3d79.tar.gz
https://direct.funtoo.org/21/63/45/216345aa64b06615778d7029e7d110a34edda4efbc5d76be465078c0660bcb9ec98438b7f6b2bd5889a137e0b2ea0fa95dab42aa84b1d03728f5f0b6de15cf4f -> ncspot-1.2.2-funtoo-crates-bundle-e1a0e00c1a9347973bbb324a23fe14cb4657fd352bf3536267095150432e5dafc0c23f41190b5272034367b2bd64f7e58a71ee8a099cc79fe9a3550063f32f2a.tar.gz"

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