TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="Configurable static site generator"
TERMUX_PKG_MAINTAINER="Florian Grässle <termux@holehan.org>"
TERMUX_PKG_VERSION=0.46
TERMUX_PKG_SHA256=3cb167e24bdbb2362415aba4b1be301596276b4ff565116cb81df95bdfc50c0a
TERMUX_PKG_SRCURL=https://github.com/gohugoio/hugo/archive/v${TERMUX_PKG_VERSION}.tar.gz

termux_step_make_install(){
  termux_setup_golang

  export GOPATH=$TERMUX_PKG_BUILDDIR
  mkdir -p $GOPATH/{bin,src/github.com/gohugoio}
  ln -fs $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/gohugoio/hugo

  termux_download https://github.com/golang/dep/releases/download/v0.4.1/dep-linux-amd64 \
    $GOPATH/bin/dep \
    31144e465e52ffbc0035248a10ddea61a09bf28b00784fd3fdd9882c8cbb2315
  chmod +x $GOPATH/bin/dep

  cd $GOPATH/src/github.com/gohugoio/hugo

  $GOPATH/bin/dep ensure -vendor-only

  export CGO_LDFLAGS="-L$TERMUX_PREFIX/lib"
  export CGO_ENABLED=1

  go build -ldflags="-s -w" -o $TERMUX_PREFIX/bin/hugo -tags extended main.go

  termux_download https://github.com/gohugoio/hugo/releases/download/v${TERMUX_PKG_VERSION}/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz \
    $TERMUX_PKG_CACHEDIR/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz \
    6df4c38800a381053c9d3971bacde132ee486d5349a0a081d6eb9b8c4e9790ba
  tar xf $TERMUX_PKG_CACHEDIR/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz -C $GOPATH/bin/ hugo

  mkdir -p $TERMUX_PREFIX/{etc/bash_completion.d,share/man/man1}
  $GOPATH/bin/hugo gen autocomplete --completionfile=$TERMUX_PREFIX/etc/bash_completion.d/hugo.sh
  $GOPATH/bin/hugo gen man --dir=$TERMUX_PREFIX/share/man/man1/
}
