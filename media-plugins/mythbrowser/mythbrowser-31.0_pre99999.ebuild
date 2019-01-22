# Copyright 1999-2008 Gentoo Foundation
# Copyright 2010-2015 Andres Kahk
# ( If you make changes, please add a copyright notice above, but
# never remove an existing notice. )
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythbrowser/mythbrowser-0.21_p16468.ebuild,v 1.1 2008/03/09 20:41:17 cardoe Exp $

EAPI=5
inherit mythtv-plugins

DESCRIPTION="Web browser module for MythTV."
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-qt/qtwebkit-5.1"
DEPEND="${RDEPEND}"


setup_pro() {
	return 0
}
