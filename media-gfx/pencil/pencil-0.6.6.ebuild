# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg

DESCRIPTION="2D animation and drawing program based on Qt5"
HOMEPAGE="https://www.pencil2d.org/"
SRC_URI="https://api.github.com/repos/pencil2d/pencil/tarball/v0.6.6 -> pencil-v0.6.6.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

src_unpack() {
	default
	rm -rf "${S}"
	mv "${WORKDIR}"/pencil2d-pencil-* "${S}" || die
}

src_prepare() {
	default
	sed -e "/^QT/s/xmlpatterns //" \
		-i core_lib/core_lib.pro tests/tests.pro || die
}

src_configure() {
	eqmake5 PREFIX=/usr $(usex test "" "CONFIG+=NO_TESTS")
}

src_install() {
	einstalldocs
	emake INSTALL_ROOT="${D}" install
	# TODO: Install l10n files
}