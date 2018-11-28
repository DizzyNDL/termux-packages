TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="Configurable static site generator"
TERMUX_PKG_MAINTAINER="Florian Grässle <hallo@holehan.org>"
TERMUX_PKG_VERSION=0.52
TERMUX_PKG_SHA256=a6c1b50c6d47c34d3d23fee1e11ad598752f39f71811b8e20db7598521fc0cc0
TERMUX_PKG_SRCURL=https://github.com/gohugoio/hugo/archive/v${TERMUX_PKG_VERSION}.tar.gz

termux_step_make_install(){
  termux_setup_golang

  export CGO_LDFLAGS="-L$TERMUX_PREFIX/lib"
  export CGO_ENABLED=1
  
  BUILD_DATE=`date -u "+%Y-%m-%dT%H:%M:%S"Z`
  GO_LDFLAGS="-w -s -X github.com/gohugoio/hugo/hugolib.BuildDate=$BUILD_DATE"
  
  cd $TERMUX_PKG_SRCDIR
  
  go build -ldflags="$GO_LDFLAGS" -o $TERMUX_PREFIX/bin/hugo -tags extended main.go

  termux_download https://github.com/gohugoio/hugo/releases/download/v${TERMUX_PKG_VERSION}/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz \
    $TERMUX_PKG_CACHEDIR/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz \
    99a74984cdae3098846c626bffb0eb578e265d70803665d3c3505be2a54e6a18
  tar xf $TERMUX_PKG_CACHEDIR/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz -C $TERMUX_PKG_CACHEDIR/ hugo

  mkdir -p $TERMUX_PREFIX/{etc/bash_completion.d,share/man/man1}
  $TERMUX_PKG_CACHEDIR/hugo gen autocomplete --completionfile=$TERMUX_PREFIX/etc/bash_completion.d/hugo.sh
  $TERMUX_PKG_CACHEDIR/hugo gen man --dir=$TERMUX_PREFIX/share/man/man1/
}
