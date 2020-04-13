FROM ubuntu:18.04 AS builder

ARG qt5_prefix=/qt5-repo/qt5-prefix
ARG qt_version_tag=5.14

RUN apt update && \
    apt install -y \
    software-properties-common

RUN add-apt-repository ppa:ubuntu-toolchain-r/test && apt update && \
    apt install -y \
    libfontconfig1-dev \
    libfreetype6-dev \
    libx11-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxrender-dev \
    libxcb1-dev \
    libx11-xcb-dev \
    libxcb-glx0-dev \
    libxkbcommon-x11-dev \
    libxcb-keysyms1-dev \
    libxcb-image0-dev \
    libxcb-shm0-dev \
    libxcb-icccm4-dev \
    libxcb-sync0-dev \
    libxcb-xfixes0-dev \
    libxcb-shape0-dev \
    libxcb-randr0-dev \
    libxcb-render-util0-dev \
    mesa-common-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libpython3-dev \
    gcc-9 g++-9 \
    make git automake automake autoconf libc6-dev
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10
WORKDIR /qt5-repo/
RUN git clone git://code.qt.io/qt/qt5.git -b ${qt_version_tag}
WORKDIR /qt5-repo/qt5
RUN perl init-repository --module-subset=default,-qtwebengine,-qtconnectivity,-qtdatavis3d,-qtdocgallery,-qtgamepad,-qtpurchasing,-qtqa,-qtsensors,-qtserialbus,-qtserialport,-qtspeech
WORKDIR /qt5-repo/build/
RUN ../qt5/configure -opensource -confirm-license \
  -prefix ${qt5_prefix} \
  -skip qtconnectivity -skip qtdatavis3d -skip qtdocgallery \
  -skip qtgamepad -skip qtpurchasing -skip qtqa -skip qtsensors \
  -skip qtserialbus -skip qtserialport -skip qtspeech \
  -skip qtwebengine -nomake tests -nomake examples -no-use-gold-linker && \
  make -j $(nproc)

FROM ubuntu:18.04
WORKDIR /qt5-repo/
COPY --from=builder /qt5-repo .
RUN apt update && apt install make
CMD ["make", "-C", "build", "install"]
