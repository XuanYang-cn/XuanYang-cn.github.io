FROM ubuntu:jammy-20221101

# pipefail is enabled for proper error detection in the `wget | apt-key add`
# step

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=UTC

ENV GOPATH /home/go
ENV GOROOT /usr/local/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:${PATH}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN echo "Installing Packages ..." \
        && apt-get update \
        && apt-get install -y --no-install-recommends \
            wget \
            curl \
            ca-certificates \
            build-essential \
            gnupg2 \
            lcov libtool m4 autoconf automake libssl-dev zlib1g-dev \
            libboost-all-dev \
            libboost-program-options-dev libboost-system-dev libboost-filesystem-dev \
            libboost-serialization-dev libboost-python-dev libboost-regex-dev \
            libcurl4-openssl-dev \
            libtbb-dev libzstd-dev libaio-dev uuid-dev libpulse-dev netcat iputils-ping liblapack3

RUN echo "Installing working tools ..." \
        && apt-get update \
        && apt-get install -y --no-install-recommends g++ gcc gfortran git make ccache python3 python3-dev python3-pip gdb gdbserver htop tig zsh vim language-pack-en xmodmap

RUN update-locale

RUN apt-get remove --purge -y && rm -rf /var/lib/apt/lists/*

RUN echo "Installing CMake ..." \
        && wget -qO- "https://github.com/Kitware/CMake/releases/download/v3.24.3/cmake-3.24.3-linux-x86_64.tar.gz" | tar --strip-components=1 -xz -C /usr/local


RUN echo "Setting up zsh ..." \
        && chsh -s $(which zsh) && $SHELL --version \
    && echo "Setting up oh-my-zsh ..." \
        && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        && wget -c "https://raw.githubusercontent.com/XuanYang-cn/Stones/master/vim/.zshrc_ubuntu" -O /root/.zshrc \
        && git clone https://github.com/zdharma-continuum/history-search-multi-word.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/history-search-multi-word\
        && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    && echo "Setting up vim ..." \
        && wget -c "https://raw.githubusercontent.com/XuanYang-cn/Stones/master/vim/.vimrc_ubuntu" -O /root/.vimrc \
        && curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


RUN echo "Installing Go ..." \
        && export GO_TARBALL="go1.18.3.linux-amd64.tar.gz"\
        && curl -fsSL "https://golang.org/dl/${GO_TARBALL}" --output "${GO_TARBALL}" \
        && tar xzf "${GO_TARBALL}" -C /usr/local \
        && rm "${GO_TARBALL}"\
        && mkdir -p "${GOPATH}/bin" \
    && echo "Installing golangci-lint ..." \
        && curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
            | sh -s -- -b ${GOPATH}/bin v1.46.2

RUN echo "Installing OpenBLAS ..." \
        && wget https://github.com/xianyi/OpenBLAS/archive/v0.3.21.tar.gz \
        && tar zxvf v0.3.21.tar.gz \
        && cd OpenBLAS-0.3.21 \
        && make NO_STATIC=1 NO_LAPACK=1 NO_LAPACKE=1 NO_CBLAS=1 NO_AFFINITY=1 USE_OPENMP=1 \
               TARGET=HASWELL DYNAMIC_ARCH=1 \ NUM_THREADS=64 MAJOR_VERSION=3 libs shared \
        && make PREFIX=/usr/local NUM_THREADS=64 MAJOR_VERSION=3 install \
        && rm -f /usr/local/include/cblas.h /usr/local/include/lapack* \
        && cd .. && rm -rf OpenBLAS-0.3.21 && rm v0.3.21.tar.gz

ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib"
