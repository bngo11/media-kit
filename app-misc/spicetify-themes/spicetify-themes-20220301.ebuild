# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A community-driven collection of themes for spicetify"
HOMEPAGE="https://github.com/morpheusthewhite/spicetify-themes"
SRC_URI="https://github.com/morpheusthewhite/spicetify-themes/archive/07596ca4b2b0798add2d76e4fee7a696f9faf86b.tar.gz -> spicetify-themes-20220301.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	app-misc/spicetify-cli
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	default
	mv spicetify-themes-* ${S} || die
}

src_prepare() {
	default
	rm -rf .gitignore CODE_OF_CONDUCT.md LICENSE README.md .github
}

src_install() {
	insinto /opt/spicetify-cli/Themes
	doins -r *

	insinto /opt/spicetify-cli/Extensions
	find . -type f -name "*.js" -exec doins {} \;
}