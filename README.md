![CI](https://github.com/bitstower/markets/workflows/CI/badge.svg)
[![Translation](https://hosted.weblate.org/widgets/markets/-/markets/svg-badge.svg)](https://hosted.weblate.org/engage/markets/?utm_source=widget)

![](data/icons/com.bitstower.Markets.svg?raw=true)

# Markets
The Markets application delivers financial data to your fingertips. Track stocks, currencies and cryptocurrencies. Stay on top of the market and never miss an investment opportunity!

## Screenshots

![](preview.png?raw=true)

## Features

* Create your personal portfolio
* Track stocks, currencies, cryptocurrencies, commodities and indexes
* Designed for Phosh (Librem5, PinePhone) and Gnome
* Open any symbol in Yahoo Finance for more details
* Adjust the refresh rate
* Dark Mode

## Installation

* Flathub: [com.bitstower.Markets](https://flathub.org/apps/details/com.bitstower.Markets)
* AUR: [bitstower-markets](https://aur.archlinux.org/packages/bitstower-markets/)

## Building from source


### Option 1: with GNOME Builder

1. Open GNOME Builder
1. Click the _Clone Repository_ button
1. Enter `https://github.com/bitstower/markets.git` in the field _Repository URL_
1. Click the _Clone Project_ button
1. Click the _Run_ button to start building application

### Option 2: with Meson

You'll need the following dependencies:

* libsoup
* libgee
* libhandy
* json-glib
* glib2
* gtk3
* meson
* vala
* ninja
* git

Clone the repository and change to the project directory

```
git clone https://github.com/bitstower/markets.git
cd markets
```

Run `meson build` to configure the build environment. Change to the build directory and run `ninja` to build

```
meson build --prefix=/usr
cd build
ninja
```

To install, use `ninja install`, then execute with `markets`

```
sudo ninja install
markets
```
