Build ThoanTaigi (Custom-made Squirrel with Rime for macOS)
===

# 1. Prerequisites
```
# install Xcode Command Line Tools
xcode-select --install

# dev tools:
brew install cmake
brew install git

# libraries:
brew install boost@1.60
brew link --force boost@1.60
```

# 2. Get source code & build
Clone the repo
```
git clone https://github.com/i3thuan5/squirrel.git
```

Get sub-modules
```
cd squirrel
git submodule deinit -f --all
git submodule update --init --recursive
```

Optionally, checkout Rime plugins (a list of GitHub repo slugs):
```
bash librime/install-plugins.sh rime/librime-sample
```

Build dependencies
```
make deps
```

Build Squirrel
```
make
```

# 3.a Install directly on your Mac
```
sudo make install
```

# 3.b Package
```
make package
```
PKG file at ./package/ThoanTaigi.pkg
