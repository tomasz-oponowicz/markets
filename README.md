# Markets

A market tracker for Linux Smartphones (Librem 5, PinePhone).


![](data/screenshots/symbols.png?raw=true)

## Build & Install

1. Install dependencies:

       sudo pacman -S libsoup libgee libhandy json-glib glib2 gtk3 meson ninja
1. Clone the repository

       git clone https://github.com/bitstower/markets.git
1. Build the application:

       cd ./markets
       meson build
       ninja
       
1. Install the application:

       sudo ninja install
