![](data/icons/com.bitstower.Markets.svg?raw=true)

# Markets
The Markets application delivers financial data to your fingertips. Track stocks, currencies and cryptocurrencies. Stay on top of the market and never miss an investment opportunity!

## Screenshots

![](data/screenshots/symbols.png?raw=true)

## Features

* Create your personal portfolio
* Track stocks, currencies, cryptocurrencies, commodities and indexes
* Compatible with Linux smartphones (Librem5, PinePhone)
* Open any symbol in Yahoo Finance for more details
* Adjust the refresh rate
* Dark Mode

## Installation

* Arch Linux AUR: [markets](https://aur.archlinux.org/packages/markets/)

## Building from source

You'll need the following dependencies:

* libsoup
* libgee
* libhandy
* json-glib
* glib2
* gtk3
* meson
* ninja

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
