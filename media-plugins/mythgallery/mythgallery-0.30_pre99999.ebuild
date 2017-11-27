# Copyright 1999-2008 Gentoo Foundation
# Copyright 2010-2015 Andres Kahk
# ( If you make changes, please add a copyright notice above, but
# never remove an existing notice. )
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythgallery/mythgallery-0.21_p16468.ebuild,v 1.1 2008/03/09 20:43:11 cardoe Exp $

EAPI=5
inherit mythtv-plugins

DESCRIPTION="Gallery and slideshow module for MythTV."
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+exif opengl"

RDEPEND="exif? ( >=media-libs/libexif-0.6.10 )
	opengl? ( virtual/opengl )
	media-libs/tiff"
DEPEND="${RDEPEND}"

src_configure() {

	export QT_SELECT=qt5

	cd "${S}/mythplugins"

	if use debug; then
		sed -e 's!CONFIG += release!CONFIG += debug!' \
		-i 'settings.pro' || die "switching to debug build failed"
	fi

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

	myconf="${myconf} $(use_enable exif)"
	myconf="${myconf} $(use_enable exif new-exif)"
	myconf="${myconf} $(use_enable opengl)"

	econf ${myconf}
}

setup_pro() {
	return 0
}
