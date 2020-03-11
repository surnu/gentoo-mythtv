# Copyright 1999-2010 Gentoo Foundation
# Copyright 2010-2015 Andres Kahk
# ( If you make changes, please add a copyright notice above, but
# never remove an existing notice. )
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythnetvision/mythnetvision-0.23_p25065.ebuild,v 1.2 2010/06/13 07:27:48 cardoe Exp $

EAPI=5

inherit mythtv-plugins
PYTHON_COMPAT=( python2_7 )

DESCRIPTION="MythTV Plugin for watching internet content"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=dev-python/pycurl-7.19.0
		>=dev-python/imdbpy-3.8
		media-tv/mythtv[python]
		media-plugins/mythbrowser
		www-plugins/adobe-flash"
DEPEND="media-plugins/mythbrowser"

setup_pro() {
	return 0
}

src_install() {
	mythtv-plugins_src_install

	# Fix up permissions
	#fperms 755 /usr/share/mythtv/mythnetvision/scripts/*.pl
	#fperms 755 /usr/share/mythtv/mythnetvision/scripts/*.py
}
