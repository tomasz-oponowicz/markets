markets_sources = [
  'Application.vala',

  'NewSymbolDialog.vala',
  'PreferencesWindow.vala',
  'SymbolsView.vala',
  'NoSymbolsView.vala',
  'SymbolRow.vala',
  'MainHeaderBar.vala',
  'SelectionHeaderBar.vala',
  'State.vala',
  'Service.vala',
  'Symbol.vala',
  'RestClient.vala',

  'MainWindow.vala',
  markets_resources
]

markets_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  dependency('libhandy-0.0', version: '>= 0.0.13'),
  dependency('libsoup-2.4', version: '>= 2.66'),
  dependency('json-glib-1.0'),
  dependency('gee-0.8')
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
