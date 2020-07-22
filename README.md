![](data/icons/com.bitstower.Markets.svg?raw=true)

# Markets

![](data/screenshots/symbols.png?raw=true)

The Markets app delivers financial data to your fingertips. Stay on top of the market and never miss an investment opportunity!

Features:
* Create your personal portfolio
* Track stocks, currencies, cryptocurrencies, commodities and indexes
* Compatible with Linux smartphones (Librem5, PinePhone)
* Open any symbol in Yahoo Finance for more details
* Adjust the refresh rate
* Dark Mode


## Build & Install

1. Install dependencies (Arch):

       sudo pacman -S libsoup libgee libhandy json-glib glib2 gtk3 meson ninja
1. Clone the repository

       git clone https://github.com/bitstower/markets.git
1. Build the application:

       cd ./markets
       meson build
       cd ./build
       ninja
       
1. Install the application:

       sudo ninja install
