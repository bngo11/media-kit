# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/456291623e9c82bc1add01682c1045265569454f -> ncspot-1.3.2-4562916.tar.gz
https://direct.funtoo.org/0b/00/9d/0b009d77923614efc63b63d27539d8b8870fc8b3c4aaf96c9d5090b4e5e71f093276d01c3cb427d6f94fe8cf6f7ac9e6f326747774f63e308b741fa389fa63ab -> ncspot-1.3.2-funtoo-crates-bundle-314cdd1f4854f3fbc64d0c42571e24f188d5ff05f5a0da521e312981956a95530d721760f4a80acece41bbc7b6e8556fec75f54d5412105335337894d9bb4164.tar.gz"

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