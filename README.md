# Markets

The Markets app delivers market data to your fingertips.

Stay on top of the market and never miss an investment opportunity.

Features:
* Create your personal portfolio
* Easily follow stocks, currencies and cryptocurrencies
* Compatible with Linux smartphones
* Open specified symbol in Yahoo Finance for more details
* Adjust pull interval
* Dark Mode

![](data/screenshots/symbols.png?raw=true)

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
