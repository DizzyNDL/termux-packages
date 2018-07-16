TERMUX_PKG_HOMEPAGE=https://sift-tool.org/
TERMUX_PKG_DESCRIPTION="A fast and powerful alternative to grep"
TERMUX_PKG_MAINTAINER="Florian Grässle <termux@holehan.org>"
TERMUX_PKG_VERSION=0.9.0
#TERMUX_PKG_SHA256=bbbd5c472c36b78896cd7ae673749d3943621a6d5523d47973ed2fc6800ae4c8
#TERMUX_PKG_SRCURL=https://github.com/svent/sift/archive/v${TERMUX_PKG_VERSION}.tar.gz

termux_step_make_install(){
  termux_setup_golang

  export GOPATH=$TERMUX_PKG_BUILDDIR

  mkdir -p $GOPATH/bin
  mkdir -p $TERMUX_PREFIX/etc/bash_completion.d

  go get github.com/svent/sift

  cp $GOPATH/bin/${GOOS}_$GOARCH/sift $TERMUX_PREFIX/bin/sift
  cp $GOPATH/src/github.com/svent/sift/sift-completion.bash $TERMUX_PREFIX/etc/bash_completion.d/
}
