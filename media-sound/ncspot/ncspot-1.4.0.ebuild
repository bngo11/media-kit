# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/1905c7967ab13c8dafa38e632205f4b53e745a0e -> ncspot-1.4.0-1905c79.tar.gz
https://direct.funtoo.org/b5/04/3e/b5043e530050ae22a19ba61ae443e78b6b2dd7002fca8b7e416a9cc42b982cd7aee2beb8dcd81d2245b34c2d5929e6ae03878cdf265247597a272aed0178deed -> ncspot-1.4.0-funtoo-crates-bundle-50634be867748a8dc26a8216d514f4345bd13b09202716e15241fb29dc1b85a4a432f4bc51c669d45442e826aca49da28273ad3e0bd3a9440ab138722b4a066f.tar.gz"

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