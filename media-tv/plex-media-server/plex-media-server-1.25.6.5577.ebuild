# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit user unpacker python-single-r1

URI="https://downloads.plex.tv/plex-media-server-new"

DESCRIPTION="A free media library that is intended for use with a plex client."
HOMEPAGE="http://www.plex.tv/"
SRC_URI="
	amd64? ( https://downloads.plex.tv/plex-media-server-new/1.25.6.5577-c8bd13540/debian/plexmediaserver_1.25.6.5577-c8bd13540_amd64.deb )
	x86? ( https://downloads.plex.tv/plex-media-server-new/1.25.6.5577-c8bd13540/debian/plexmediaserver_1.25.6.5577-c8bd13540_i386.deb )
"

SLOT="0"
LICENSE="Plex"
RESTRICT="mirror bindist strip"
KEYWORDS="*"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

IUSE="system-openssl avahi"

DEPEND="
	dev-python/virtualenv[${PYTHON_USEDEP}]
"

RDEPEND="
	avahi? ( net-dns/avahi )
	system-openssl? ( dev-libs/openssl:0 )
	${PYTHON_DEPS}"

QA_DESKTOP_FILE="usr/share/applications/plexmediamanager.desktop"
QA_PREBUILT="*"
QA_MULTILIB_PATHS=(
	"usr/lib/plexmediaserver/.*"
	"usr/lib/plexmediaserver/Resources/Python/lib/python2.7/.*"
)

S="${WORKDIR}"

pkg_setup() {
	enewgroup plex
	enewuser plex -1 /bin/bash /var/lib/plexmediaserver "plex,video"
	python-single-r1_pkg_setup
}

src_prepare(){
	cp -r "${FILESDIR}/usr" "${S}"
	default
}

src_install() {
	# Move the config to the correct place
	dodir "/etc/plex"
	insinto "/etc/plex"
	doins "${FILESDIR}/plexmediaserver"

	# Remove Debian specific files
	rm -rf "usr/share/doc" || die

	# Remove buggy openssl library
	if use system-openssl; then
		rm -f usr/lib/plexmediaserver/libssl.so.1.0.0 || die
	fi

	# Copy main files over to image and preserve permissions so it is portable
	cp -rp usr/ "${ED}" || die

	# Make sure the logging directory is created
	local LOGGING_DIR="/var/log/pms"
	dodir "${LOGGING_DIR}"
	chown plex:plex "${ED%/}/${LOGGING_DIR}" || die
	keepdir "${LOGGING_DIR}"

	# Create default library folder with correct permissions
	local DEFAULT_LIBRARY_DIR="/var/lib/plexmediaserver"
	dodir "${DEFAULT_LIBRARY_DIR}"
	chown plex:plex "${ED%/}/${DEFAULT_LIBRARY_DIR}" || die
	keepdir "${DEFAULT_LIBRARY_DIR}"

	# Install the OpenRC init/conf files depending on avahi.
	if use avahi; then
		doinitd "${FILESDIR}/init.d/${PN}"
	else
		cp "${FILESDIR}/init.d/${PN}" "${S}/${PN}";
		sed -e '/depend/ s/^#*/#/' -i "${S}/${PN}"
		sed -e '/need/ s/^#*/#/' -i "${S}/${PN}"
		sed -e '1,/^}/s/^}/#}/' -i "${S}/${PN}"
		doinitd "${S}/${PN}"
	fi

	doconfd "${FILESDIR}/conf.d/${PN}"

	# Mask Plex libraries so that revdep-rebuild doesn't try to rebuild them.
	# Plex has its own precompiled libraries.
	_mask_plex_libraries_revdep

	einfo "Configuring virtualenv"
	virtualenv -v --no-pip --no-setuptools --no-wheel "${ED}"/usr/lib/plexmediaserver/Resources/Python || die
	pushd "${ED}"/usr/lib/plexmediaserver/Resources/Python &>/dev/null || die
	find . -type f -exec sed -i -e "s#${D}##g" {} + || die
	popd &>/dev/null || die
}

pkg_postinst() {
	einfo ""
	elog "Plex Media Server is now installed. Please check the configuration file in /etc/plex/plexmediaserver to verify the default settings."
	elog "To start the Plex Server, run 'rc-config start plex-media-server', you will then be able to access your library at http://<ip>:32400/web/"
}

# Adds the precompiled plex libraries to the revdep-rebuild's mask list
# so it doesn't try to rebuild libraries that can't be rebuilt.
_mask_plex_libraries_revdep() {
	dodir /etc/revdep-rebuild/
	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/usr/$(get_libdir)/plexmediaserver\"" > "${ED}"/etc/revdep-rebuild/80plexmediaserver
}

