---
TITLE: "How To Build Develop Environment with Vim"
date: 2022-11-22T18:30:27+08:00
draft: false
toc: true
images:
categories:
  - tools
tags:
  - vim
---

This article helps myself to quickly establish a workable environments in Ubuntu with vim for

- The following languages: Golang, Python, CPP, MarkDown.
- Auto completion, jump to definition, rename variables, jump to files, jump to greps, auto lint
- Shell tools: git, rg, hugo, etc.

## Just use docker

1. Download docker
2. Use [Dockerfile](https://raw.githubusercontent.com/XuanYang-cn/XuanYang-cn.github.io/master/content/posts/OS/Dockerfile)

## I have a really Ubuntu
### 1. Install essentials

#### Maybe important
```shell
$ sudp apt update && apt install wget curl ca-certificates build-essential gnupg2 lcov libtool m4 autoconf automake libssl-dev zlib1g-dev libboost-all-dev libboost-program-options-dev libboost-system-dev libboost-filesystem-dev libboost-serialization-dev libboost-python-dev libboost-regex-dev libcurl4-openssl-dev libtbb-dev libzstd-dev libaio-dev uuid-dev libpulse-dev netcat iputils-ping liblapack3 libblas-dev liblapack-dev
```

#### Very important
```shell
$ sudo apt update && apt install g++ gcc gfortran git make ccache python3 python3-dev python3-pip gdb gdbserver htop tig zsh vim language-pack-en xmodmap hugo ripgrep global universal-ctags terminator
$ sudo apt remove --purge -y && sudo rm -rf /var/lib/apt/lists/*
```

```shell
# install CMake
$ wget -qO- "https://github.com/Kitware/CMake/releases/download/v3.24.3/cmake-3.24.3-linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr/local

# Setting up zsh
$ chsh -s $(which zsh) && $SHELL --version
$ pip install powerline-status
$ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
$ git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts && ./install.sh && cd .. && rm -rf fonts
$ wget -c "https://raw.githubusercontent.com/XuanYang-cn/Stones/master/vim/.zshrc_ubuntu" -O $HOME/.zshrc
$ git clone https://github.com/zdharma-continuum/history-search-multi-word.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-search-multi-word
$ git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
$ wget -c "https://raw.githubusercontent.com/XuanYang-cn/Stones/master/vim/.vimrc_ubuntu" -O $HOME/.vimrc
$ curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

```shell
# Setting up python work space
$ python3 -m pip install --user virtualenv virtualenvwrapper

# Setting up golang work space
$ export GO_TARBALL="go1.18.3.linux-amd64.tar.gz"
$ export GOPATH=$HOME/go
$ curl -fsSL "https://golang.org/dl/${GO_TARBALL}" --output "${GO_TARBALL}
$ tar xzf "${GO_TARBALL}" -C /usr/local && rm "${GO_TARBALL}" && mkdir -p "${GOPATH}/bin"
$ curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b ${GOPATH}/bin v1.46.2
```

``` shell
# Install Openblas
$ wget https://github.com/xianyi/OpenBLAS/archive/v0.3.21.tar.gz
$ tar zxvf v0.3.21.tar.gz && cd OpenBLAS-0.3.21
$ make NO_STATIC=1 NO_LAPACK=1 NO_LAPACKE=1 NO_CBLAS=1 NO_AFFINITY=1 USE_OPENMP=1 TARGET=HASWELL DYNAMIC_ARCH=1 \ NUM_THREADS=64 MAJOR_VERSION=3 libs shared
$ make PREFIX=/usr/local NUM_THREADS=64 MAJOR_VERSION=3 install
$ rm -f /usr/local/include/cblas.h /usr/local/include/lapack*
$ cd .. && rm -rf OpenBLAS-0.3.21 && rm v0.3.21.tar.gz
```

**Don't forget to compile YouCompleteMe!**

#### Resources might be useful
|Plugin|URL|
|---|---|
|YouCompleteMe|https://github.com/ycm-core/YouCompleteMe|
|ale|https://github.com/dense-analysis/ale|
|LeaderF|https://github.com/Yggdroot/LeaderF|
|gtags|`man gtags.conf`|
