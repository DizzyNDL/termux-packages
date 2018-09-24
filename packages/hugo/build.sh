TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="Configurable static site generator"
TERMUX_PKG_MAINTAINER="Florian Grässle <hallo@holehan.org>"
TERMUX_PKG_VERSION=0.49
TERMUX_PKG_SHA256=a31e0bac3a8c2884ed156b696fa1f63aa90b5898b537d30fbbdb95311ffa3e83
TERMUX_PKG_SRCURL=https://github.com/gohugoio/hugo/archive/v${TERMUX_PKG_VERSION}.tar.gz

termux_step_make_install(){
  termux_setup_golang

  export CGO_LDFLAGS="-L$TERMUX_PREFIX/lib"
  export CGO_ENABLED=1
  
  BUILD_DATE=`date -u "+%Y-%m-%dT%H:%M:%S"`
  GO_LDFLAGS="-w -s -X github.com/gohugoio/hugo/hugolib.BuildDate=$BUILD_DATE"
  
  cd $TERMUX_PKG_SRCDIR
  
  go build -ldflags="$GO_LDFLAGS" -o $TERMUX_PREFIX/bin/hugo -tags extended main.go

  termux_download https://github.com/gohugoio/hugo/releases/download/v${TERMUX_PKG_VERSION}/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz \
    $TERMUX_PKG_CACHEDIR/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz \
    150d9a75e6d47f3196d9972846c3828170f746f1f2e904da2732a411dc54dd38
  tar xf $TERMUX_PKG_CACHEDIR/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz -C $TERMUX_PKG_CACHEDIR/ hugo

  mkdir -p $TERMUX_PREFIX/{etc/bash_completion.d,share/man/man1}
  $TERMUX_PKG_CACHEDIR/hugo gen autocomplete --completionfile=$TERMUX_PREFIX/etc/bash_completion.d/hugo.sh
  $TERMUX_PKG_CACHEDIR/hugo gen man --dir=$TERMUX_PREFIX/share/man/man1/
}
