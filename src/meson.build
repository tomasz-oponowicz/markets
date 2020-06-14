markets_sources = [
  'Main.vala',
  'Window.vala',
]

markets_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
]

gnome = import('gnome')

markets_sources += gnome.compile_resources('markets-resources',
  'markets.gresource.xml',
  c_name: 'markets'
)

executable('markets', markets_sources,
  vala_args: '--target-glib=2.50',  dependencies: markets_deps,
  install: true,
)
