markets_sources = [
  'Main.vala',
  'Window.vala',
  markets_sources
]

markets_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
]

executable('markets', markets_sources,
  vala_args: '--target-glib=2.50',  dependencies: markets_deps,
  install: true,
)
