# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/55d00c6ab768a7b5a1c74840c2b7e1e77270fadd -> ncspot-1.3.1-55d00c6.tar.gz
https://direct.funtoo.org/9f/5b/c4/9f5bc4b15506090db4494b949ae85782f92471a6b01da771e6b42f8136677d3aabad2afdc3d72ea5083ae389197c0e27b5567cc3e0504d853b8939dcf2655f1e -> ncspot-1.3.1-funtoo-crates-bundle-43b579b134ece9b72314c67e8226d80db8d530f22527ec6f0c573ef4ab150059287c8e47e879cd373f81fa2ddd7821b61c98c75dc10901ce5c10f631debaebee.tar.gz"

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