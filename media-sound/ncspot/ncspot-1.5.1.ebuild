# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Cross-platform ncurses Spotify client written in Rust, inspired by ncmpc and the likes."
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/tarball/2897c518211cf76c21179a3ac526d4ee5c485077 -> ncspot-1.5.1-2897c51.tar.gz
https://direct.funtoo.org/d3/60/8d/d3608d2e15a4d102c1c60085b4fa863701c939a5906812e9424c55df80da824de5c26edcb42be34cd98c1b5ea6839fafc553d2fab76890d290b71a07281cd682 -> ncspot-1.5.1-funtoo-crates-bundle-1a40e1e0bb54219db99eaf3fe8aa726b2195998c74c7544a5836291ad5c9c2bbe3298252ee7be3c83106bfad186f06c2009b09dd333fc79c1a7a1f1ad96f8140.tar.gz"

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