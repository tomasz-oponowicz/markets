app_sources = [
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
  app_constants,
  app_ui_resources
]

app_deps = [
  dependency('gio-2.0', version: '>= 2.50'),
  dependency('gtk+-3.0', version: '>= 3.22'),
  dependency('libhandy-1', version: '>= 1.0.0'),
  dependency('libsoup-2.4', version: '>= 2.66'),
  dependency('json-glib-1.0'),
  dependency('gee-0.8')
]

app_c_args = [
  '-DHANDY_USE_UNSTABLE_API',
]

executable(app_binary, app_sources,
  vala_args: '--target-glib=2.50',
  dependencies: app_deps,
  c_args: app_c_args,
  install: true,
)
