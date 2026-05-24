# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/71861ff4e71b4aeda032a0547fad83ec5f126267 -> ncspot-1.3.4-71861ff.tar.gz
https://direct.funtoo.org/d7/26/f9/d726f9ffebde9664d7808f027bd3678e59dadd94985286e60af06074fb318045447f9c1fe5585b50f954c6d2457c8623574bae76f1d6cd68e29108a3d99f8477 -> ncspot-1.3.4-funtoo-crates-bundle-dafe7559942324c5b19fd293e5e4cc85def50c55fe55ec65737fc3713719f08b156df170ebee9d6e7d5f28c63bf4c2d05ea0dd9501cef93be648fc92bda1263c.tar.gz"

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