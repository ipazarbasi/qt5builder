# Image for building Qt
This Dockerfile creates a builder that builds a Qt library with selected
submodules, and allows users to install it on top of the host machine as a user.

# Instructions
* Create a builder:

    docker build --build-arg qt5_prefix=$HOME/qt5-prefix -t some-name/qt:5.14.2 .

* Run the container by mounting destination as volume, and it will install the
files.

    docker run --rm -v $HOME/qt5-prefix:$HOME/qt5-trunk/qt5-prefix --user \
    `id -u`:`id -g` some-name/qt:5.14.2
