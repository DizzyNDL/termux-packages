TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="Configurable static site generator"
TERMUX_PKG_MAINTAINER="Florian Grässle <termux@holehan.org>"
TERMUX_PKG_VERSION=0.44
TERMUX_PKG_SHA256=63e6ae4be7e7b23ab5551842182b49be9a9a07a82d217c1a7a2815b49976129d
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
    9ebed7fba3e12ce104dbdf525e52b8ed956c3d361ef3989b40ef484c82d43a6e
  tar xf $TERMUX_PKG_CACHEDIR/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz -C $GOPATH/bin/ hugo

  mkdir -p $TERMUX_PREFIX/{etc/bash_completion.d,share/man/man1}
  $GOPATH/bin/hugo gen autocomplete --completionfile=$TERMUX_PREFIX/etc/bash_completion.d/hugo.sh
  $GOPATH/bin/hugo gen man --dir=$TERMUX_PREFIX/share/man/man1/
}
