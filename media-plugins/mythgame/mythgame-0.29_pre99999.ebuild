# Copyright 1999-2008 Gentoo Foundation
# Copyright 2010-2015 Andres Kahk
# ( If you make changes, please add a copyright notice above, but
# never remove an existing notice. )
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythgame/mythgame-0.21_p16468.ebuild,v 1.1 2008/03/09 20:44:09 cardoe Exp $

EAPI=5
inherit mythtv-plugins

DESCRIPTION="Game emulator module for MythTV."
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

src_unpack() {
	git-2_src_unpack
	mythtv-plugins_src_unpack_patch

	#gentoo zlib patch
	epatch "${FILESDIR}"/mythgame-zlib-fix.patch
}

src_install () {
	mythtv-plugins_src_install
        cd "${S}/mythplugins/${PN}"
	dodoc gamelist.xml
}

setup_pro() {
	return 0
}
