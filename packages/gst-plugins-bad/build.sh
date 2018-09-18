TERMUX_PKG_HOMEPAGE=https://gstreamer.freedesktop.org/
TERMUX_PKG_DESCRIPTION="GStreamer Bad Plug-ins"
TERMUX_PKG_VERSION=1.14.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=34fab7da70994465a64468330b2168a4a0ed90a7de7e4c499b6d127c6c1b1eaf
TERMUX_PKG_SRCURL=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="gst-plugins-base, libbz2, libcurl, libpng, librsvg, libssh2, libsndfile, libx264, libx265, littlecms, openal-soft, openjpeg"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-android_media
--disable-examples
--disable-rtmp
--disable-tests
--disable-zbar
--disable-webp
--with-hls-crypto=openssl
"
TERMUX_PKG_RM_AFTER_INSTALL="share/gtk-doc/"

termux_step_pre_configure() {
	export GNUSTL_LIBS="-lc"
	export GNUSTL_CFLAGS="-Oz"
}
