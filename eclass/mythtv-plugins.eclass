# Copyright 1999-2006 Gentoo Foundation
# Copyright 2010-2015 Andres Kahk
# ( If you make changes, please add a copyright notice above, but
# never remove an existing notice. )
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/mythtv-plugins.eclass,v 1.34 2009/01/13 23:16:10 gentoofan23 Exp $
#
# Author: Doug Goldstein <cardoe@gentoo.org>
#
# Installs MythTV plugins along with patches from the release-${PV}-fixes branch
#

PYTHON_COMPAT=( python2_7 )

inherit mythtv multilib versionator git-2 python-single-r1

# Extra configure options to pass to econf
MTVCONF=${MTVCONF:=""}

SLOT="0"
IUSE="${IUSE} debug cpu_flags_x86_mmx"

if [[ -z $MYTHTV_NODEPS ]] ; then
RDEPEND="${RDEPEND}
		=media-tv/mythtv-${MY_PV}*"
DEPEND="${DEPEND}
		=media-tv/mythtv-${MY_PV}*
		>=sys-apps/sed-4"
fi

S="${WORKDIR}/mythplugins-${MY_PV}"

QTDIR="/usr"

# bug 240325
RESTRICT="strip"

mythtv-plugins_pkg_setup() {

	# List of available plugins (needs to include ALL of them in the tarball)
	MYTHPLUGINS="mytharchive mythbrowser mythgallery mythgame"
	MYTHPLUGINS="${MYTHPLUGINS} mythmusic mythnetvision mythnews"
	MYTHPLUGINS="${MYTHPLUGINS} mythweather mythzoneminder"
}

mythtv-plugins_src_unpack() {
	git-2_src_unpack
	mythtv-plugins_src_unpack_patch
}

mythtv-plugins_src_unpack_patch() {
	cd "${S}/mythplugins"

	sed -e 's!PREFIX = /usr/local!PREFIX = /usr!' \
	-i 'settings.pro' || die "fixing PREFIX to /usr failed"

	sed -e "s!QMAKE_CXXFLAGS_RELEASE = -O3 -march=pentiumpro -fomit-frame-pointer!QMAKE_CXXFLAGS_RELEASE = ${CXXFLAGS}!" \
	-i 'settings.pro' || die "Fixing QMake's CXXFLAGS failed"

	sed -e "s!QMAKE_CFLAGS_RELEASE = \$\${QMAKE_CXXFLAGS_RELEASE}!QMAKE_CFLAGS_RELEASE = ${CFLAGS}!" \
	-i 'settings.pro' || die "Fixing Qmake's CFLAGS failed"

	find "${S}" -name '*.pro' -exec sed -i \
		-e "s:\$\${PREFIX}/lib/:\$\${PREFIX}/$(get_libdir)/:g" \
		-e "s:\$\${PREFIX}/lib$:\$\${PREFIX}/$(get_libdir):g" \
	{} \;

	setup_pro
}

mythtv-plugins_src_configure() {

	export QT_SELECT=qt5

	cd "${S}/mythplugins"

	if use debug; then
		sed -e 's!CONFIG += release!CONFIG += debug!' \
		-i 'settings.pro' || die "switching to debug build failed"
	fi

#	if ( use x86 && ! use mmx ) || ! use amd64 ; then
	if ( ! use cpu_flags_x86_mmx ); then
		sed -e 's!DEFINES += HAVE_MMX!DEFINES -= HAVE_MMX!' \
		-i 'settings.pro' || die "disabling MMX failed"
	fi

	local myconf=""

	if has ${PN} ${MYTHPLUGINS} ; then
		for x in ${MYTHPLUGINS} ; do
			if [[ ${PN} == ${x} ]] ; then
				myconf="${myconf} --enable-${x}"
			else
				myconf="${myconf} --disable-${x}"
			fi
		done
	else
		die "Package ${PN} is unsupported"
	fi

	econf ${myconf} ${MTVCONF}
}

mythtv-plugins_src_compile() {
	cd "${S}/mythplugins"
	${QTDIR}/bin/qmake QMAKE="${QTDIR}/bin/qmake" -o "Makefile" mythplugins.pro || die "qmake failed to run"
	emake || die "make failed to compile"
}

mythtv-plugins_src_install() {
	cd "${S}/mythplugins"
	if has ${PN} ${MYTHPLUGINS} ; then
		cd "${S}"/mythplugins/${PN}
	else
		die "Package ${PN} is unsupported"
	fi

	einstall INSTALL_ROOT="${D}"
	for doc in AUTHORS COPYING FAQ UPGRADING ChangeLog README; do
		test -e "${doc}" && dodoc ${doc}
	done
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_configure src_compile src_install
