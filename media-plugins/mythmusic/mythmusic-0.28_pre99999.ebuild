# Copyright 1999-2008 Gentoo Foundation
# Copyright 2010-2015 Andres Kahk
# ( If you make changes, please add a copyright notice above, but
# never remove an existing notice. )
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythmusic/mythmusic-0.21_p16468.ebuild,v 1.1 2008/03/09 20:46:34 cardoe Exp $

EAPI=5
inherit mythtv-plugins flag-o-matic toolchain-funcs eutils

DESCRIPTION="Music player module for MythTV."
IUSE="cdr fftw opengl sdl"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=media-sound/cdparanoia-3.9.8
	>=media-libs/libmad-0.15.1b
	>=media-libs/libcdaudio-0.99.6
	>=media-libs/flac-1.1.2
	>=media-libs/libogg-1.1.4
	>=media-libs/libvorbis-1.0
	>=media-libs/taglib-1.4
	fftw? ( sci-libs/fftw )
	opengl? ( virtual/opengl )
	cdr? ( virtual/cdrtools )
	"

DEPEND="${RDEPEND}"

MTVCONF="$(use_enable fftw) $(use_enable opengl)"

setup_pro() {
	return 0
}
