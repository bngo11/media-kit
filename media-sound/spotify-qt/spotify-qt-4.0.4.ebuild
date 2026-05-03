# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Lightweight Spotify client using Qt"
HOMEPAGE="https://github.com/kraxarn/spotify-qt"
SRC_URI="https://github.com/kraxarn/spotify-qt/tarball/a5eeff4fa0459d507d3f7b8583cf6f5a53c43540 -> spotify-qt-4.0.4-a5eeff4.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}/kraxarn-spotify-qt-a5eeff4"

RDEPEND="
  dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}"

src_prepare() {
  cmake_src_prepare
}