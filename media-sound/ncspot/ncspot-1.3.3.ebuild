# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/d76e1db5e6bb16b5e745268c27e531d946561ac1 -> ncspot-1.3.3-d76e1db.tar.gz
https://direct.funtoo.org/04/a0/b3/04a0b30127135392c29e8bf3436635c269cca963249109f58670a0323e1dd1702d9ce10e6c0fe6eb378d61a790b5ef0bb79cb2eb832b090893cf7c8b7b088bb4 -> ncspot-1.3.3-funtoo-crates-bundle-573d579466e73d9f64f6ef69979dd7ff27d977b27df1006846d53c62376f06a6bc0855a7f2b64cf23bc99cbf975f8b3d530dd96b5156229471e85f52b5e449cb.tar.gz"

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