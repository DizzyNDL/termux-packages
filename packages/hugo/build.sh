TERMUX_PKG_HOMEPAGE=https://gohugo.io/
TERMUX_PKG_DESCRIPTION="Configurable static site generator"
TERMUX_PKG_MAINTAINER="Florian Grässle <termux@holehan.org>"
TERMUX_PKG_VERSION=0.47
TERMUX_PKG_SHA256=81ce60555e4d5aadbbae355035daae578d95616d0e79bfd23639f8c21a56da29
TERMUX_PKG_SRCURL=https://github.com/gohugoio/hugo/archive/v${TERMUX_PKG_VERSION}.tar.gz

termux_step_make_install(){
  termux_setup_golang

  export GOPATH=$TERMUX_PKG_BUILDDIR
  mkdir -p $GOPATH/{bin,src/github.com/gohugoio}
  ln -fs $TERMUX_PKG_SRCDIR $GOPATH/src/github.com/gohugoio/hugo

  termux_download https://github.com/golang/dep/releases/download/v0.5.0/dep-linux-amd64 \
    $GOPATH/bin/dep \
    287b08291e14f1fae8ba44374b26a2b12eb941af3497ed0ca649253e21ba2f83
  chmod +x $GOPATH/bin/dep

  cd $GOPATH/src/github.com/gohugoio/hugo

  $GOPATH/bin/dep ensure -vendor-only

  export CGO_LDFLAGS="-L$TERMUX_PREFIX/lib"
  export CGO_ENABLED=1

  go build -ldflags="-s -w" -o $TERMUX_PREFIX/bin/hugo -tags extended main.go

  termux_download https://github.com/gohugoio/hugo/releases/download/v${TERMUX_PKG_VERSION}/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz \
    $TERMUX_PKG_CACHEDIR/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz \
    a46efb11c727f535f686dfa0086b705f3f1f716289785b4a67f1a7cffdbfafec
  tar xf $TERMUX_PKG_CACHEDIR/hugo_extended_${TERMUX_PKG_VERSION}_Linux-64bit.tar.gz -C $GOPATH/bin/ hugo

  mkdir -p $TERMUX_PREFIX/{etc/bash_completion.d,share/man/man1}
  $GOPATH/bin/hugo gen autocomplete --completionfile=$TERMUX_PREFIX/etc/bash_completion.d/hugo.sh
  $GOPATH/bin/hugo gen man --dir=$TERMUX_PREFIX/share/man/man1/
}
