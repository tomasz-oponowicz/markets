markets_sources = [
  'Main.vala',

  'NewSymbolDialog.vala',
  'PreferencesWindow.vala',
  'SymbolsView.vala',
  'SymbolRow.vala',
  'HeaderBar.vala',

  'Window.vala',
  markets_resources
]

markets_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  dependency('libhandy-0.0', version: '>= 0.0.13'),
]

markets_c_args = [
  '-DHANDY_USE_UNSTABLE_API',
]


executable('markets', markets_sources,
  vala_args: '--target-glib=2.50',
  dependencies: markets_deps,
  c_args: markets_c_args,
  install: true,
)
