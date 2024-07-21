# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/7ce6e532fca311883bc855b43a83b8e8a7b9e616 -> ncspot-1.1.2-7ce6e53.tar.gz
https://direct.funtoo.org/68/11/67/6811674e4c8ff8db202decff2b11cb780510e057dc67ce2044f15982e262a63cef9e083765495db552a22140ee9fcccb70633600290abbbf82b540c0f49f650c -> ncspot-1.1.2-funtoo-crates-bundle-dbfe11dcf358a640da377515fc30f5ae06d96d76d57457300c801754338fd1f1f8ef70ec79a47eb54fce7389ca01f5a6fe3a4e53af2ddfead49cb3ebe3449df5.tar.gz"

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