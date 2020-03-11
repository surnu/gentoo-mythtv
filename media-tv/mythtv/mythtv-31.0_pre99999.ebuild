# Copyright 1999-2008 Gentoo Foundation
# Copyright 2010-2015 Andres Kahk
# ( If you make changes, please add a copyright notice above, but
# never remove an existing notice. )
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/mythtv/mythtv-0.22_alpha16508.ebuild,v 1.1 2008/03/11 19:56:58 cardoe Exp $

EAPI=6
MYTHTV_BRANCH="master"
PYTHON_COMPAT=( python3_{6,7} )

inherit flag-o-matic multilib eutils mythtv toolchain-funcs user systemd python-any-r1

DESCRIPTION="Homebrew PVR project"
HOMEPAGE="http://www.mythtv.org"
SRC_URI=""

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE_VIDEO_CARDS="video_cards_nvidia video_cards_via"
IUSE="cpu_flags_x86_mmx cpu_flags_x86_mmxext cpu_flags_x86_mmxext cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 \
cpu_flags_x86_ssse3 cpu_flags_x86_sse4_2 cpu_flags_x86_3dnow cpu_flags_x86_3dnowext cpu_flags_x86_avx cpu_flags_x86_fma4 \
alsa altivec autostart backendonly bluray +css cec debug directv dvb dvd \
egl fftw +hls hdhomerun ieee1394 ivtv jack joystick lcd libass lirc opengl \
opengl-video perl php pulseaudio python raop rtmp sdl systemd tiff theora \
vaapi vorbis vdpau xml xmltv +xvid ${IUSE_VIDEO_CARDS}"



REQUIRED_USE="
        bluray? ( xml )
        theora? ( vorbis )"

COMMON="media-gfx/exiv2
	>=media-libs/freetype-2.0
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXxf86vm
	>=dev-qt/qtcore-5.1:5
	>=dev-qt/qtdbus-5.1:5
	>=dev-qt/qtgui-5.1:5
	>=dev-qt/qtscript-5.1:5
	>=dev-qt/qtsql-5.1:5[mysql]
	>=dev-qt/qtopengl-5.1:5
	>=dev-qt/qtwebkit-5.1:5
	>=dev-qt/qtwidgets-5.1:5
	>=dev-qt/qtxml-5.1:5
	x11-misc/wmctrl
	media-libs/libsamplerate
	virtual/mysql
	virtual/opengl
	alsa? ( >=media-libs/alsa-lib-1.0.24 )
	bluray? (
	        dev-libs/libcdio
	        media-libs/libbluray
	)
	cec? ( dev-libs/libcec )
	directv? ( virtual/perl-Time-HiRes )
	dvb? (
		media-libs/libdvb
		virtual/linuxtv-dvb-headers
	)
	dvd? (
		dev-libs/libcdio
		media-libs/libdvdnav
		media-libs/libdvdcss
	)
	egl? ( media-libs/mesa[egl] )
	fftw? ( sci-libs/fftw:3.0 )
	hls? (
		media-libs/libvpx
		>=media-libs/x264-0.0.20110426
		>=media-libs/x265-1.8
		>=media-sound/lame-3.93.1
	)
	ieee1394? (
		>=sys-libs/libraw1394-1.2.0
		>=sys-libs/libavc1394-0.5.0
		>=media-libs/libiec61883-1.0.0
	)
	ivtv? ( media-tv/ivtv )
	jack? ( media-sound/jack-audio-connection-kit )
	lcd? ( app-misc/lcdproc )
	libass? ( media-libs/libass )
	lirc? ( app-misc/lirc )
	perl? (
		dev-perl/DBD-mysql
		dev-perl/Net-UPnP
		dev-perl/LWP-Protocol-https
		dev-perl/HTTP-Message
		dev-perl/IO-Socket-INET6
		>=dev-perl/libwww-perl-6
	)
	pulseaudio? ( media-sound/pulseaudio )
	python? (
		dev-python/lxml
		dev-python/future
		dev-python/simplejson
		dev-python/requests
		dev-python/mysqlclient
	)
	raop? (
		dev-libs/openssl
		net-dns/avahi[mdnsresponder-compat]
	)
	rtmp? ( media-video/rtmpdump )
	sdl? ( media-libs/libsdl )
	systemd? ( sys-apps/systemd )
	theora? ( media-libs/libtheora )
	vaapi? ( x11-libs/libva )
	vdpau? ( x11-libs/libvdpau )
	vorbis? ( >=media-libs/libvorbis-1.0 )
	xml? ( >=dev-libs/libxml2-2.6.0 )
	xvid? ( >=media-libs/xvid-1.1.0 )
	"

RDEPEND="${COMMON}
	media-fonts/corefonts
	media-fonts/dejavu
	media-fonts/liberation-fonts
	autostart? (
		net-dialup/mingetty
		x11-wm/evilwm
		x11-apps/xset
	)
	xmltv? ( >=media-tv/xmltv-0.5.43 )
	"

DEPEND="${COMMON}
	dev-lang/yasm
	!backendonly? (
		x11-apps/xinit
	)"

S="${WORKDIR}/${PN}-${MY_PV}"

MYTHTV_GROUPS="video,audio,tty,uucp"

pkg_setup() {

	python-any-r1_pkg_setup

	einfo "This ebuild now uses a heavily stripped down version of your CFLAGS"
	enewuser mythtv -1 /bin/bash /home/mythtv ${MYTHTV_GROUPS}
	usermod -a -G ${MYTHTV_GROUPS} mythtv
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {

	cd "${S}/mythtv"

	# upstream wants the revision number in their version.cpp
	# since the subversion.eclass strips out the .svn directory
	# svnversion in MythTV's build doesn't work
	## For GIT Testing
	MYTHTV_VERSION=$(git describe)
	sed -e "s#\${SOURCE_VERSION}#${MYTHTV_VERSION}#g" \
	    -e "s#\${BRANCH}#${MYTHTV_BRANCH}#g" \
	    -i "${S}"/mythtv/version.sh

	# Perl bits need to go into vender_perl and not site_perl
	sed -e "s:pure_install:pure_install INSTALLDIRS=vendor:" \
		-i "${S}"/mythtv/bindings/perl/Makefile

	epatch "${FILESDIR}"/sandbox-2.0.patch
	eapply_user
}

src_configure() {
	cd "${S}/mythtv"
#	local myconf="--prefix=/usr
#		--mandir=/usr/share/man
#		--libdir-name=$(get_libdir)"
#		--incdir=/usr/include/mythtv

	local myconf=

	# Setup paths
	myconf="${myconf} --prefix=${EPREFIX}/usr"
	myconf="${myconf} --libdir=${EPREFIX}/usr/$(get_libdir)"
	myconf="${myconf} --libdir-name=$(get_libdir)"
	myconf="${myconf} --mandir=${EPREFIX}/usr/share/man"

        # Audio
	myconf="${myconf} $(use_enable alsa audio-alsa)"
	myconf="${myconf} $(use_enable jack audio-jack)"
	use pulseaudio || myconf="${myconf} --disable-audio-pulseoutput"

	use altivec || myconf="${myconf} --disable-altivec"
	myconf="${myconf} $(use_enable dvb)"
	myconf="${myconf} $(use_enable ieee1394 firewire)"
	myconf="${myconf} $(use_enable lirc)"
	myconf="${myconf} $(use_enable joystick joystick-menu)"

	myconf="${myconf} $(use_enable xvid libxvid)"
	myconf="${myconf} --dvb-path=/usr/include"
	myconf="${myconf} --enable-xrandr"
	myconf="${myconf} --enable-x11"

	use cec || myconf="${myconf} --disable-libcec"
	use raop || myconf="${myconf} --disable-libdns-sd"

	if use hls; then
		myconf="${myconf} --enable-nonfree"
		myconf="${myconf} --enable-libmp3lame"
		myconf="${myconf} --enable-libx264"
		myconf="${myconf} --enable-libx265"
		myconf="${myconf} --enable-libvpx"
	else
		myconf="${myconf} --enable-gpl"
	fi

	use sdl && myconf="${myconf} --enable-sdl"
	use fftw && myconf="${myconf} --enable-libfftw3"
	use hdhomerun || myconf="${myconf} --disable-hdhomerun"
	use ivtv || myconf="${myconf} --disable-ivtv"

	#Video
	myconf+=(
		$(use_enable opengl opengl-video)
		$(use_enable opengl opengl-themepainter)
	)

	use vaapi && myconf="${myconf} --enable-vaapi"
	use rtmp && myconf="${myconf} --enable-librtmp"
	if use vdpau; then
		myconf="${myconf} --enable-vdpau"
	else
		myconf="${myconf} --disable-vdpau"
	fi

	myconf="${myconf} $(use_enable cpu_flags_x86_mmx mmx)"
	myconf="${myconf} $(use_enable cpu_flags_x86_mmxext mmxext)"
	myconf="${myconf} $(use_enable cpu_flags_x86_sse sse)"
	myconf="${myconf} $(use_enable cpu_flags_x86_sse2 sse2)"
	myconf="${myconf} $(use_enable cpu_flags_x86_sse3 sse3)"
	myconf="${myconf} $(use_enable cpu_flags_x86_ssse3 ssse3)"
	myconf="${myconf} $(use_enable cpu_flags_x86_sse4_2 sse42)"
	myconf="${myconf} $(use_enable cpu_flags_x86_3dnow amd3dnow)"
	myconf="${myconf} $(use_enable cpu_flags_x86_3dnowext amd3dnowext)"
	myconf="${myconf} $(use_enable cpu_flags_x86_avx avx)"
	myconf="${myconf} $(use_enable cpu_flags_x86_fma4 fma4)"

	if use perl && use python && use php; then
		myconf="${myconf} --with-bindings=perl,php,python"
	elif use perl && use python; then
		myconf="${myconf} --with-bindings=perl,python"
	elif use perl && use php; then
		myconf="${myconf} --with-bindings=perl,php"
	elif use php && use python; then
		myconf="${myconf} --with-bindings=php,python"
	elif use perl; then
		myconf="${myconf} --with-bindings=perl"
	elif use python; then
		myconf="${myconf} --with-bindings=python"
	elif use php; then
		myconf="${myconf} --with-bindings=php"
	else
		myconf="${myconf} --without-bindings=perl, php, python"
	fi

	if use debug; then
		myconf="${myconf} --compile-type=debug"
	else
		myconf="${myconf} --compile-type=profile"
	fi

	## CFLAG cleaning so it compiles
	MARCH=$(get-flag "march")
	MTUNE=$(get-flag "mtune")
	#strip-flags
	#filter-flags "-march=*" "-mtune=*" "-mcpu=*"
	#filter-flags "-O" "-O?"

	if [[ -n "${MARCH}" ]]; then
		myconf="${myconf} --cpu=${MARCH}"
	fi
	if [[ -n "${MTUNE}" ]]; then
		myconf="${myconf} --tune=${MTUNE}"
	fi

#	myconf="${myconf} --extra-cxxflags=\"${CXXFLAGS}\" --extra-cflags=\"${CFLAGS}\""
	has distcc ${FEATURES} || myconf="${myconf} --disable-distcc"
	has ccache ${FEATURES} || myconf="${myconf} --disable-ccache"

	# let MythTV come up with our CFLAGS. Upstream will support this
	CFLAGS=""
	CXXFLAGS=""
	einfo "Running ./configure ${myconf}"
	./configure ${myconf} || die "configure died"
}

src_compile() {
	cd "${S}/mythtv"
	emake || die "emake failed"
}

src_install() {

	cd "${S}/mythtv"
	emake INSTALL_ROOT="${D}" install || die "install failed"
	dodoc AUTHORS UPGRADING README

	insinto /usr/share/mythtv/database
	doins database/*

	exeinto /usr/share/mythtv
	doexe "${FILESDIR}/mythfilldatabase.cron"

	exeinto /etc/init.d
	newinitd "${FILESDIR}"/mythbackend.rc6 mythbackend
	insinto /etc/conf.d
	newconfd "${FILESDIR}"/mythbackend.conf mythbackend
	systemd_newunit "${FILESDIR}"/mythbackend.service mythbackend.service
	
	dodoc keys.txt
	#dodoc keys.txt docs/*.{txt,pdf}
	#dohtml docs/*.html

	keepdir /etc/mythtv
	chown -R mythtv "${D}"/etc/mythtv
	keepdir /var/{log,run}/mythtv
	chown -R mythtv "${D}"/var/{log,run}/mythtv

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/mythtv.logrotate.d mythtv

	insinto /usr/share/mythtv/contrib
	doins -r contrib/*

	dobin "${FILESDIR}"/runmythfe

	if use autostart; then
		dodir /etc/env.d/
		echo 'CONFIG_PROTECT="/home/mythtv/"' > /etc/env.d/95mythtv

		insinto /home/mythtv
		newins "${FILESDIR}"/autostart/bash_profile .bash_profile
		newins "${FILESDIR}"/autostart/xinitrc .xinitrc
	fi

	# Make Python files executable
	find "${ED}/usr/share/mythtv" -type f -name '*.py' | while read file; do
		if [[ ! "${file##*/}" = "__init__.py" ]]; then
			chmod a+x "${file}"
		fi
	done
	
	# Ensure that Python scripts are executed by Python 2
	python_fix_shebang "${ED}/usr/share/mythtv"

	# Make shell & perl scripts executable
	find "${ED}" -type f -name '*.sh' -o -type f -name '*.pl' | \
		while read file; do
		chmod a+x "${file}"
	done

}

pkg_preinst() {
	export CONFIG_PROTECT="${CONFIG_PROTECT} ${EROOT}/home/mythtv/"
}

pkg_postinst() {

	use python

	elog
	elog "To always have MythBackend running and available run the following:"
	elog "rc-update add mythbackend default"
	elog
	ewarn "Your recordings folder must be owned by the user 'mythtv' now"
	ewarn "chown -R mythtv /path/to/store"

	elog "Want mythfrontend to start automatically?"
	elog "Set USE=autostart. Details can be found at:"
	elog "http://dev.gentoo.org/~cardoe/mythtv/autostart.html"

	if use autostart; then
		elog
		elog "Please add the following to your /etc/inittab file at the end of"
		elog "the TERMINALS section"
		elog "c8:2345:respawn:/sbin/mingetty --autologin mythtv tty8"
	fi

	elog
	ewarn "Beware when you change ANY packages on your system that it may"
	ewarn "break some or all of the MythTV components. MythTV's build system"
	ewarn "is very fragile and only supports automagic dependencies."
	ewarn "i.e. It depends on libraries and components it finds at build time"
	ewarn "We try to mitigate this with RDEPENDs but be prepared to run"
	ewarn "revdep-rebuild as necessary."

}

pkg_postrm()
{
	use python
}

pkg_info() {
	if [[ -f "${EROOT}"/usr/bin/mythfrontend ]]; then
		"${EROOT}"/usr/bin/mythfrontend --version
	fi
}

pkg_config() {
	echo "Creating mythtv MySQL user and mythconverg database if it does not"
	echo "already exist. You will be prompted for your MySQL root password."
	"${EROOT}"/usr/bin/mysql -u root -p < "${EROOT}"/usr/share/mythtv/database/mc.sql
}
