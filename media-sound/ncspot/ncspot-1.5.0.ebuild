# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/addc84286d5b2c71bac8831c2cf41897baddf0ab -> ncspot-1.5.0-addc842.tar.gz
https://direct.funtoo.org/d0/70/5d/d0705d7b744146be06edae5ce1e6e946d7afa8b1ded226c2b31ee58a6d3c10db215579adc719f5e0b40fb66919d4b82e21fa84bffa7e28139254cc94176365a0 -> ncspot-1.5.0-funtoo-crates-bundle-07e0860317ceb7f796b4a48e6c8116335d39186b40ee6effcae0af8b447cb8afbeed70b791f25716b36127b68a8a319d8347c582bbed05015f3249e88554f717.tar.gz"

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