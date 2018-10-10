TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="Configurable static site generator"
TERMUX_PKG_MAINTAINER="Florian Grässle <hallo@holehan.org>"
TERMUX_PKG_VERSION=0.49.1
TERMUX_PKG_SHA256=1ee074a6421c29b22dd3d7b6b86b45b6d7d13f46e8c841433845d3c96ca57ac6
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
    d382df482af9cef6f131c791941b1b9c26a5686b0db59136ef6a89a81ae0ff58
  tar xf $TERMUX_PKG_CACHEDIR/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz -C $TERMUX_PKG_CACHEDIR/ hugo

  mkdir -p $TERMUX_PREFIX/{etc/bash_completion.d,share/man/man1}
  $TERMUX_PKG_CACHEDIR/hugo gen autocomplete --completionfile=$TERMUX_PREFIX/etc/bash_completion.d/hugo.sh
  $TERMUX_PKG_CACHEDIR/hugo gen man --dir=$TERMUX_PREFIX/share/man/man1/
}
